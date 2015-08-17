require_dependency "diabetic_toolbox/application_controller"

class DiabeticToolbox::MemberSessionsController < DiabeticToolbox::ApplicationController
  load_and_authorize_resource class: 'DiabeticToolbox::Member'
  respond_to :html, :json

  def new
    @member          = DiabeticToolbox::Member.new
    there_can_be_only_one
  end

  def create
    @member = request.env['warden'].authenticate! scope: :member

    if request.env['warden'].authenticated? scope: :member
      flash[:success] = I18n.t('views.member_sessions.messages.login_success')
      redirect_to login_successful_path
    else
      there_can_be_only_one
      render :new
    end
  end

  def destroy
    request.env['warden'].logout :member

    redirect_to root_url
  end

  def password_recovery
    there_can_be_only_one
  end

  # TODO: Must create a mailer to send the recovery kit to the member.
  def send_recovery_kit
  end

  private
    def member_params
      params.require(:member).permit :email, :password
    end

    def there_can_be_only_one
      @ensure_cohesion = true
    end

    def login_successful_path
      if @member.settings.count > 0
        member_dashboard_path
      else
        setup_path
      end
    end
end
