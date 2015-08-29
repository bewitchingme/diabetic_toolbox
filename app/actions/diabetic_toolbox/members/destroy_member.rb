module DiabeticToolbox
  rely_on :action

  # = DestroyMember
  #
  # This action allows for the destruction of a member and is used
  # as follows:
  #
  #   result = DestroyMember.new(member_id).call
  #
  #   if result.success?
  #     # Success
  #   else
  #     # Failure
  #   end
  #
  class DestroyMember < Action
    #:enddoc:
    def initialize(member_id)
      super nil

      @member = Member.find member_id
    end

    def _call
      if @member.destroy
        success do |option|
          option[:subject] = @member
          option[:message] = I18n.t('flash.member.destroyed.success')
        end
      else
        failure do |option|
          option[:subject] = @member
          option[:message] = I18n.t('flash.member.destroyed.failure')
        end
      end
    end
  end
end