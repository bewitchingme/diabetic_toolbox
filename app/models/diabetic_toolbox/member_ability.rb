class DiabeticToolbox::MemberAbility
  include CanCan::Ability

  def initialize(member)
    @member = member

    self_manage if @member.present?
  end

  private
    def self_manage
      can [:manage, :dash], DiabeticToolbox::Member,  id:        @member.id
      can [:manage],        DiabeticToolbox::Setting, member_id: @member.id
      can [:destroy],       :member_session,          member_id: @member.id
    end
end