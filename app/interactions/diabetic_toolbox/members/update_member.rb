module DiabeticToolbox
  # = UpdateMember
  #
  # This action allows for the modification of a Member and is used as follows:
  #
  #   result = UpdateMember.new(member_id, params).call
  #
  #   if result.success?
  #     # Success
  #   else
  #     # Failure
  #   end
  #
  class UpdateMember < Exchange
    #:enddoc:
    def initialize(member_id, member_params)
      super(member_params)

      @member = Member.find(member_id)
    end

    def _call
      if @member.update call_params
        success do |option|
          option.subject = @member
          option.message = I18n.t('flash.member.updated.success')
        end
      else
        failure do |option|
          option.subject = @member
          option.message = I18n.t('flash.member.updated.failure')
        end
      end
    end
  end
end