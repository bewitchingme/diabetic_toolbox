module DiabeticToolbox
  # = MemberSession
  #
  # MemberSession is responsible for creating the database requirements for
  # session data.  It is used as follows:
  #
  # ==== Creation
  #
  #   session = MemberSession.new(remote_ip_address, params)
  #   member  = session.create
  #
  #   if session.in_progress?
  #     flash[:success] = session.result_message
  #     # Success
  #   else
  #     flash[:failure] = session.result_message
  #     # Failure
  #   end
  #
  # ==== Static Methods
  #
  # To find a session that is in progress, use:
  #
  #   MemberSession.find session_token
  #
  # To destroy a session that is in progress, use:
  #
  #   MemberSession.destroy session_token
  #
  class MemberSession
    # :enddoc:
    #region Requirements
    require 'digest'
    #endregion

    #region Init
    def initialize(remote_addr, params)
      @ip      = remote_addr
      @params  = params
      @member  = Member.find_by_email @params['email']
      @success = false
      check_the_lock
    end
    #endregion

    #region Instance Methods
    def create
      if @member.present? && unlocked?
        return @member if authenticates?(@params['password']) && housekeeping?
      end
    end

    def in_progress?
      @success
    end

    def result_message
      if in_progress?
        I18n.t('views.member_sessions.messages.login_success')
      else
        if unlocked?
          I18n.t('views.member_sessions.messages.login_failure')
        else
          I18n.t('views.member_sessions.messages.account_locked')
        end
      end
    end

    def locked?
      @locked.eql? true
    end

    def unlocked?
      @locked.eql? false
    end
    #endregion

    #region Static
    def self.find(session_token)
      @member = DiabeticToolbox::Member.find_by_session_token(session_token) if session_token.present?
      @member
    end

    def self.destroy(session_token)
      @member = self.find(session_token)
      return true if @member && self.clear
    end
    #endregion

    #region Private
    private
    def check_the_lock
      @locked = false

      if @member.present? && @member.last_locked_at.present? && @member.unlock_token.present?
        @locked = true
      end
    end

    def authenticates?(password)
      if unlocked? && @member.authenticate(password)
        @success = true
      else
        log_failed_attempt
      end

      @success
    end

    def housekeeping?
      if @success
        updates = {
            last_session_began_at:    @member.current_session_began_at,
            last_session_ip:          @member.current_session_ip,
            session_token:            new_token,
            current_session_began_at: Time.now,
            current_session_ip:       @ip,
            failed_attempts:          nil
        }

        @member.update_columns updates
      end
    end

    def log_failed_attempt
      if last_attempt_before_lock?
        lock!
      else
        Member.increment_counter :failed_attempts, @member.id
      end
    end

    def lock!
      @locked = true
      updates = {
        unlock_token: new_token,
        last_locked_at: Time.now,
        failed_attempts: DiabeticToolbox.max_attempts
      }

      @member.update_columns updates
    end

    def last_attempt_before_lock?
      (@member.failed_attempts.to_i + 1) >= DiabeticToolbox.max_attempts
    end

    def new_token
      return Digest::SHA2.hexdigest( Time.now.to_f.to_s )
    end

    def self.clear
      @member.update_attribute :session_token, nil
    end
    #endregion
  end
end