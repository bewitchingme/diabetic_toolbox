require_dependency "diabetic_toolbox/application_controller"

class DiabeticToolbox::MemberSessionsController < DiabeticToolbox::ApplicationController
  respond_to :html, :json

  def new
    @member          = DiabeticToolbox::Member.new
    @ensure_cohesion = true
  end

  def create
    @member = DiabeticToolbox::Members::Session.create member_params
    session[:session_token] = @member.session_token
    redirect_to member_dash_path(@member)
  end

  def destroy
    if DiabeticToolbox::Members::Session.destroy session[:session_token]
      session.delete :session_token
    end
    redirect_to root_url
  end

  def password_recovery
    @ensure_cohesion = true
  end

  def send_recovery_kit

  end

  private
    def member_params
      params.require(:member_session).permit :email, :password
    end
end
