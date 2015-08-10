class DiabeticToolbox::MemberAbility
  include CanCan::Ability

  def initialize(member)
    @member = member

    show_interest
    self_manage if @member.present?
  end

  private
    def show_interest
      can [:new, :create],  DiabeticToolbox::Member
      can [:start, :about], :welcome
      can [:new],           :member_sessions
    end

    def self_manage
      can [:manage, :dash], DiabeticToolbox::Member,  id:        @member.id
      can [:manage],        DiabeticToolbox::Setting, member_id: @member.id
      can [:destroy],       :member_sessions,         member_id: @member.id
    end
end