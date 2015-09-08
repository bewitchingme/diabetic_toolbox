module DiabeticToolbox
  rely_on :action

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
  class ChangeMemberEmail < Action
    #:enddoc:
    def initialize(member_id, member_params)
      super member_params
      @member = Member.find(member_id)
    end

    protected
    def _call
      if @member.update @params
        success do |option|
          option.message = I18n.t('flash.member.updated_email.success')
          option.subject = @member
        end
      else
        failure do |option|
          option.message = I18n.t('flash.member.updated_email.failure')
          option.subject = @member
        end
      end
    end

    def _after_call
      if @result.success?
        # TODO: Record was updated, now we send a confirmation email
        # TODO: with a hash assigned to confirmation_token to complete
        # TODO: this process.
      end
    end
  end
end