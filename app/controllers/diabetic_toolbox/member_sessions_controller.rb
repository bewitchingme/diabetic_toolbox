require_dependency "diabetic_toolbox/application_controller"

class DiabeticToolbox::MemberSessionsController < DiabeticToolbox::ApplicationController
  load_and_authorize_resource class: 'DiabeticToolbox::Member'
  respond_to :html, :json

  def new
    @member          = DiabeticToolbox::Member.new
    @ensure_cohesion = true
  end

  def create
    @session = DiabeticToolbox::Members::Session.new
    @member  = @session.create member_params

    if @session.in_progress?
      session[:session_token] = @member.session_token
      flash[:success]         = @session.result_message

      redirect_to member_dashboard_path(@member)
    else
      flash[:danger]   = @session.result_message
      @ensure_cohesion = true

      render :new
    end
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

  # TODO: Must create a mailer to send the recovery kit to the member.
  def send_recovery_kit
  end

  private
    def member_params
      params.require(:member).permit :email, :password
    end
end
