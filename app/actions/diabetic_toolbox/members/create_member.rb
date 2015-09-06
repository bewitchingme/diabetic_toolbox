module DiabeticToolbox
  rely_on :action

  # = CreateMember
  #
  # This action allows for the creation of a new authenticatable Member.
  # To use CreateMember see the following:
  #
  #   result = CreateMember.new(params).call
  #
  #   if result.success?
  #     # Success
  #   else
  #     # Failure
  #   end
  #
  class CreateMember < Action
    # :enddoc:
    def initialize(member_params)
      super member_params
    end

    protected
    def _call
      @member = Member.new @params

      if @member.save
        success do |option|
          option.subject = @member
          option.message = I18n.t('flash.member.created.success', first_name: @member.first_name)
        end
      else
        failure do |option|
          option.subject = @member
          option.message = I18n.t('flash.member.created.failure')
        end
      end
    end

    def _after_call
      # TODO: Must implement the mailer here to confirm the member.
    end
  end
end