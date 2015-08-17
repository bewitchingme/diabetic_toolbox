Warden::Strategies.add(:standard) do
  def valid?
    member_params = params['member']
    member_params['email'] && member_params['password']
  end

  def authenticate!
    member = DiabeticToolbox::Members::Session.new(env, params['member']).create
    member.nil? ? fail!("Could not log in") : success!(member)
  end
end
