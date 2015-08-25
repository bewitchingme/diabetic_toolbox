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

      @member_id = member_id

      @succeeded = lambda do |option|
        option[:subject] = member
        option[:message] = I18n.t('flash.member.updated.success')
      end

      @failed = lambda do |option|
        option[:subject] = member
        option[:message] = I18n.t('flash.member.updated.failure')
      end
    end

    ##
    # Initiates the action to update the member.
    #
    # :call-seq:
    #   call(id = nil) => DiabeticToolbox::Result::Base
    #
    def _call
      member = Member.find(@member_id)

      if member.update @params
        success &@succeeded
      else
        failure &@failed
      end
    end
  end
end