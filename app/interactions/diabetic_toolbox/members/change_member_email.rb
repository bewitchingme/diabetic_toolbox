require 'digest'

module DiabeticToolbox
  # = ChangeMemberEmail
  #
  # This action allows for the modification of a Member email address and is used as follows:
  #
  #   result = ChangeMemberEmail.new(member_id, params).call
  #
  #   if result.success?
  #     # Success
  #   else
  #     # Failure
  #   end
  #
  class ChangeMemberEmail < Exchange
    #:enddoc:
    #region Init
    def initialize(member_id, member_params)
      super member_params
      @member = Member.find(member_id)
      @in_use = Member.exists? email: @params[:unconfirmed_email]
    end
    #endregion

    #region Hooks
    hook :default do
      call_params.merge! confirmation_values
      change_request_successful = false
      change_request_successful = @member.update( call_params ) unless email_in_use?

      if change_request_successful
        success do |option|
          option.message = I18n.t('flash.member.updated_email.success')
          option.subject = @member
        end
      else
        failure do |option|
          option.message = I18n.t('flash.member.updated_email.failure') unless email_in_use?
          option.message = I18n.t('flash.member.updated_email.taken') if email_in_use?
          option.subject = @member
        end
      end
    end

    hook :after do
      if call_result.success?
        ChangeMemberEmailMailer.send_confirmation_link(@member).deliver_now
      end
    end
    #endregion

    #region Private
    private
    def confirmation_values
      {confirmation_token: ChangeMemberEmail.create_token, confirmation_sent_at: Time.now}
    end

    def email_in_use?
      @in_use
    end
    #endregion

    #region Static
    public
    def self.create_token
      Digest::SHA2.hexdigest Time.now.to_s
    end
    #endregion
  end
end