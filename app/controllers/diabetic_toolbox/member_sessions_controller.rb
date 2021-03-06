require_dependency 'diabetic_toolbox/application_controller'

module DiabeticToolbox
  #:enddoc:
  class MemberSessionsController < ApplicationController
    #region Class Methods
    authorize_resource class: false
    respond_to :html, :json
    #endregion

    #region Sign In
    def new
      redirect_when_signed_in
      @member = Member.new
      there_can_be_only_one
    end

    def create
      redirect_when_signed_in
      @member = sign_in!

      if sign_in_params.has_key? :remember_me
        cookies[:remembrance_token] = { value: @member.remembrance_token, expires: DiabeticToolbox.remember_for }
      end

      if authenticated?
        flash[:success] = I18n.t('views.member_sessions.messages.login_success')
        redirect_to login_successful_path
      else
        there_can_be_only_one
        render :new
      end
    end
    #endregion

    #region Sign Out
    def destroy
      DiabeticToolbox::MemberSession.destroy current_member.session_token
      sign_out

      redirect_to root_url
    end
    #endregion

    #region Forgot Password?
    def password_recovery
      there_can_be_only_one
      @member = Member.new
    end

    def send_recovery_kit
      DiabeticToolbox.from :members, require: %w(recover_member_password)

      result       = RecoverMemberPassword.new(recovery_params).call
      flash[:info] = result.flash

      if result.success?
        redirect_to root_path
      else
        @member = Member.new
        render :password_recovery
      end
    end
    #endregion

    #region Special Account Changes
    def reconfirm
      DiabeticToolbox.from :members, require: %w(reconfirm_member)
      sign_out

      result = DiabeticToolbox::ReconfirmMember.new( params[:token] ).call

      if result.success?
        flash[:success] = result.flash
        redirect_to sign_in_path
      else
        flash[:danger] = result.flash
        redirect_to sign_in_path
      end
    end

    def recover
      sign_out
      @member  = Member.new
    end

    def release
      DiabeticToolbox.from :members, require: %w(release_member)

      result = ReleaseMember.new( params[:token], release_params ).call

      if result.success?
        flash[:success] = result.flash
        redirect_to sign_in_path
      else
        @member = result.actual
        flash[:danger] = result.flash
        render :recover
      end
    end
    #endregion

    #region Change Email
    def edit_email
      if member_signed_in?
        @member = current_member
      end
    end

    def update_email
      DiabeticToolbox.from :members, require: %w(change_member_email)

      result = ChangeMemberEmail.new( current_member.id, change_email_params ).call

      respond_to do |format|
        format.html do
          if result.success?
            flash[:info] = result.flash
            redirect_to edit_member_path result.actual
          else
            @member         = result.actual
            flash[:warning] = result.flash
            render :edit_email
          end
        end

        format.json { render json: result.response }
      end
    end
    #endregion

    #region Private
    private
    def sign_in_params
      params.require(:member).permit :email, :password, :remember_me
    end

    def change_email_params
      params.require(:member).permit :unconfirmed_email, :unconfirmed_email_confirmation
    end

    def recovery_params
      params.require(:member).permit :email
    end

    def release_params
      params.require(:member).permit :password, :password_confirmation
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

    def redirect_when_signed_in
      if member_signed_in?
        redirect_to member_dashboard_path if current_member.configured?
        redirect_to setup_path unless current_member.configured?
      end
    end
    #endregion
  end
end