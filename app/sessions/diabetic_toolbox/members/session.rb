module DiabeticToolbox::Members
  class Session
    require 'digest'

    ##
    # Returns the DiabeticToolbox::Member upon successful session creation.
    #
    # :call-seq:
    #   create(member_params) => DiabeticToolbox::Member
    #
    def self.create(params)
      @member = DiabeticToolbox::Member.find_by_email params[:email]
      return @member if self.authenticates?(params[:password]) && self.token_saved?
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
      def self.authenticates?(password)
        @member && @member.authenticate(password)
      end

      def self.token_saved?
        @member.update_attribute :session_token, self.new_session_token
      end

      def self.new_session_token
        return Digest::SHA2.hexdigest( Time.now.to_f.to_s )
      end

      def self.clear
        @member.update_attribute :session_token, nil
      end

  end
end