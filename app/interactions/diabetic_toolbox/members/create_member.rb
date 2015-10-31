module DiabeticToolbox
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
  class CreateMember < Exchange
    # :enddoc:
    #region Init
    def initialize(member_params)
      super member_params
    end
    #endregion

    #region Hooks
    hook :default do
      @member = Member.new call_params

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
    #endregion
  end
end