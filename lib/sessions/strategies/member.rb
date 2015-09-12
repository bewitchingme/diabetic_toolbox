Warden::Strategies.add(:member) do
  def valid?
    member_params = params['member']
    member_params['email'] && member_params['password']
  end

  def authenticate!
    member_session = DiabeticToolbox::MemberSession.new( env['REMOTE_ADDR'], params['member'] )
    member         = member_session.create

    session[:result_message] = member_session.result_message unless member_session.in_progress?

    member_session.in_progress? ? success!(member) : fail!('Could not log in')
  end
end
