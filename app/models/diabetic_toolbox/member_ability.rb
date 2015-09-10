module DiabeticToolbox
  class MemberAbility
    include CanCan::Ability

    #region Init
    def initialize(member)
      @member = member

      show_interest
      self_manage if @member.present?
    end
    #endregion

    #region Private
    private
    #region Groupings
    def show_interest
      can [:new, :create],  Member
      can [:start, :about], :welcome
      visiting
    end

    def self_manage
      can [:manage, :dash, :confirm_delete], Member,  id:        @member.id
      can [:manage],                         Setting, member_id: @member.id
      authenticated
    end
    #endregion

    #region Authenticatable
    def authenticated
      can [
        :destroy, :reconfirm,
        :edit_email, :update_email
      ], :member_session
    end

    def visiting
      actions = [
        :new, :create,
        :password_recovery,
        :send_recovery_kit
      ]
      can actions, :member_session
    end
    #endregion
    #endregion
  end
end