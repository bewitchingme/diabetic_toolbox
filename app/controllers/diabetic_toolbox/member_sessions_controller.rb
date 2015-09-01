require_dependency "diabetic_toolbox/application_controller"

module DiabeticToolbox
  class MemberSessionsController < ApplicationController
    load_and_authorize_resource class: 'DiabeticToolbox::Member'
    respond_to :html, :json

    def new
      @member = Member.new
      there_can_be_only_one
    end

    def create
      @member = sign_in

      if authenticated?
        flash[:success] = I18n.t('views.member_sessions.messages.login_success')
        redirect_to login_successful_path
      else
        there_can_be_only_one
        render :new
      end
    end

    def destroy
      DiabeticToolbox::MemberSession.destroy current_member.session_token
      sign_out

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
      if @member.configured?
        member_dashboard_path
      else
        setup_path
      end
    end
  end
end