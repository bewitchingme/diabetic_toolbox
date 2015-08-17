module DiabeticToolbox::Members
  class Session
    require 'digest'
    require 'cgi'

    def initialize(env, params)
      @env     = env
      @params  = params
      @member  = nil
      @success = false
    end

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

    # :enddoc:
    private
      def authenticates?(password)
        @member && @member.authenticate(password)
      end

      def housekeeping?
        updates = {
            last_session_began_at: @member.current_session_began_at,
            last_session_ip: @member.current_session_ip,
            session_token: new_session_token,
            current_session_began_at: Time.now,
            current_session_ip: @env['REMOTE_ADDR']
        }

        @member.update_attributes updates
      end

      def new_session_token
        return Digest::SHA2.hexdigest( Time.now.to_f.to_s )
      end

      def self.clear
        @member.update_attribute :session_token, nil
      end

  end
end