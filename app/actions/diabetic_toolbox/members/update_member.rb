module DiabeticToolbox
  class UpdateMember
    ##
    # SAFE outlines which attributes of the active record model are
    # approved for return to the caller using #safe_model_data
    SAFE = [:first_name, :last_name, :username, :slug]

    ##
    # Construct with the parameters for the member.
    #
    # :call-seq:
    #   new(id, member_params) => Boolean
    #
    def initialize(id, member_params)
      @member_id = id
      @params    = member_params
    end

    ##
    # Initiates the action to update the member.
    #
    # :call-seq:
    #   call(id = nil) => DiabeticToolbox::Result::Base
    #
    def call
      member = Member.find @member_id

      if member.update @params
        Result::Success.new model: member, message: I18n.t('flash.member.updated.success'), safe: SAFE
      else
        Result::Failure.new model: member, message: I18n.t('flash.member.updated.failure'), safe: SAFE
      end
    end
  end
end