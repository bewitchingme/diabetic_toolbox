module DiabeticToolbox
  rely_on :action

  class UpdateMember < Action
    ##
    # Construct with the parameters for the member.
    #
    # :call-seq:
    #   new(id, member_params) => Boolean
    #
    def initialize(member_id, member_params)
      super(member_params)

      @member = Member.find(member_id)
    end

    ##
    # Initiates the action to update the member.
    #
    # :call-seq:
    #   call(id = nil) => DiabeticToolbox::Result::Base
    #
    def _call
      if @member.update @params
        success do |option|
          option[:subject] = @member
          option[:message] = I18n.t('flash.member.updated.success')
        end
      else
        failure do |option|
          option[:subject] = @member
          option[:message] = I18n.t('flash.member.updated.failure')
        end
      end
    end
  end
end