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
    def initialize(remote_user_ip_address, params)
      @ip      = remote_user_ip_address
      @params  = params
      @member  = nil
      @success = false
    end
    #endregion

    #region Instance Methods
    def create
      @member = DiabeticToolbox::Member.find_by_email @params['email']

      if @member.present?
        @success = true
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
        I18n.t('views.member_sessions.messages.login_failure')
      end
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

    def authenticates?(password)
      @member && @member.authenticate!(password)
    end

    def housekeeping?
      updates = {
          last_session_began_at:    @member.current_session_began_at,
          last_session_ip:          @member.current_session_ip,
          session_token:            new_session_token,
          current_session_began_at: Time.now,
          current_session_ip:       @ip
      }

      @member.update_attributes updates
    end

    def new_session_token
      return Digest::SHA2.hexdigest( Time.now.to_f.to_s )
    end

    def self.clear
      @member.update_attribute :session_token, nil
    end
    #endregion
  end
end