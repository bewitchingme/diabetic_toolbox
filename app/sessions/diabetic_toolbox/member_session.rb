module DiabeticToolbox
  class MemberSession
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
    ##
    # Returns the DiabeticToolbox::Member upon successful session creation.
    #
    # :call-seq:
    #   create(member_params) => DiabeticToolbox::Member
    #
    def create
      @member = DiabeticToolbox::Member.find_by_email @params['email']

      if @member.present?
        @success = true
        return @member if authenticates?(@params['password']) && housekeeping?
      end
    end

    ##
    # Returns true if the session is in progress, false if a session could
    # not be established.
    #
    # :call-seq:
    #   in_progress? => Boolean
    #
    def in_progress?
      @success
    end

    ##
    # Localized result message for the authentication attempt.
    #
    # :call-seq:
    #   result_message => String
    #
    def result_message
      if in_progress?
        I18n.t('views.member_sessions.messages.login_success')
      else
        I18n.t('views.member_sessions.messages.login_failure')
      end
    end
    #endregion

    #region Static
    ##
    # Returns the DiabeticToolbox::Member that matches the session token.
    #
    # :call-seq:
    #   find(session_token) => DiabeticToolbox::Member
    #
    def self.find(session_token)
      @member = DiabeticToolbox::Member.find_by_session_token(session_token) if session_token.present?
      @member
    end

    ##
    # Destroy the member with the provided session token.
    #
    # :call-seq:
    #   destroy(session_token) => Boolean
    #
    def self.destroy(session_token)
      @member = self.find(session_token)
      return true if @member && self.clear
    end
    #endregion

    # :enddoc:
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