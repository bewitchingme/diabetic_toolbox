module DiabeticToolbox
  rely_on :action

  class DestroyMember < Action
    ##
    # Construct with the id of the member to be destroyed.
    #
    # :call-seq:
    #   new(member_id) => Boolean
    #
    def initialize(member_id)
      super nil

      @member = Member.find member_id
    end

    ##
    # Initiates the action to destroy the member.
    #
    # :call-seq:
    #   call() => DiabeticToolbox::Members::CreateMember
    #
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