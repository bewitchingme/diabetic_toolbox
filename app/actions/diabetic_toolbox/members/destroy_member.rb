module DiabeticToolbox
  class DestroyMember
    ##
    # Construct with the id of the member to be destroyed.
    #
    # :call-seq:
    #   new(member_id) => Boolean
    #
    def initialize(member_id)
      @member_id = member_id
    end

    ##
    # Initiates the action to destroy the member.
    #
    # :call-seq:
    #   call() => DiabeticToolbox::Members::CreateMember
    #
    def call
      member = Member.find @member_id

      if member.destroy
        Result::Success.new model: member, message: I18n.t('flash.member.destroyed.success')
      else
        Result::Failure.new model: member, message: I18n.t('flash.member.destroyed.failure')
      end
    end
  end
end