# TODO: Must implement the mailer here to confirm the member.
module DiabeticToolbox
  # The DiabeticToolbox::Members::CreateMember action is used to
  # create a new member and prepare resulting response data
  # to the caller.
  class CreateMember
    ##
    # SAFE outlines which attributes of the active record model are
    # approved for return to the caller using #safe_model_data
    SAFE = [:first_name, :last_name, :username, :slug]

    ##
    # Construct with the parameters for the member.
    #
    # :call-seq:
    #   new(member_params) => Boolean
    #
    def initialize(member_params)
      @params = member_params
    end

    ##
    # Initiates the action to create the member.
    #
    # :call-seq:
    #   call() => DiabeticToolbox::Members::CreateMember
    #
    def call
      @member = Member.new @params

      if @member.save
        Result::Success.new model: @member, message: I18n.t('flash.member.created.success', first_name: @member.first_name), safe: SAFE
      else
        Result::Failure.new model: @member, message: I18n.t('flash.member.created.failure'), safe: SAFE
      end
    end
  end
end