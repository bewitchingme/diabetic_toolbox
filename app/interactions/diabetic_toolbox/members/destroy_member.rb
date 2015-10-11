module DiabeticToolbox
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
  class DestroyMember < Exchange
    #:enddoc:
    #region Init
    def initialize(member_id)
      super nil

      @member = Member.find member_id
    end
    #endregion

    #region Hooks
    hook :default do
      if @member.destroy
        success do |option|
          option.subject = @member
          option.message = I18n.t('flash.member.destroyed.success')
        end
      else
        failure do |option|
          option.subject = @member
          option.message = I18n.t('flash.member.destroyed.failure')
        end
      end
    end
    #endregion
  end
end