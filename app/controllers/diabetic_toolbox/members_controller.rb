require_dependency "diabetic_toolbox/application_controller"

module DiabeticToolbox
  class MembersController < DiabeticToolbox::ApplicationController
    #region Class methods
    load_and_authorize_resource
    respond_to :html, :json
    #endregion

    #region Before Action
    before_action :deploy_member_tabs,    only: :dash
    before_action :set_member,            only: [:show, :edit]
    before_action :there_can_be_only_one, only: :new
    #endregion

    #region Creation
    def new
      @member = Member.new
    end

    def create
      DiabeticToolbox.from :members, require: %w(create_member)

      result  = CreateMember.new( member_params ).call

      respond_to do |format|
        format.html do
          if result.success?
            sign_in_new_member
            flash[:success] = result.flash
            redirect_to setup_path
          else
            @member         = result.actual
            flash[:warning] = result.flash
            render :new
          end
        end

        format.json { render :json => result.response }
      end
    end
    #endregion

    #region Read
    def show
    end

    def edit
    end

    def confirm_delete
    end
    #endregion

    #region Mutation
    def update
      DiabeticToolbox.from :members, require: %w(update_member)

      result = UpdateMember.new( params[:id], member_params ).call

      respond_to do |format|
        format.html do
          if result.success?
            flash[:info] = result.flash
            redirect_to edit_member_path result.actual
          else
            @member         = result.actual
            flash[:warning] = result.flash
            render :edit
          end
        end

        format.json { render :json => result.response }
      end
    end

    def destroy
      DiabeticToolbox.from :members, require: %w(destroy_member)

      result = DestroyMember.new( params[:id] ).call

      sign_out if result.success?

      respond_to do |format|
        format.html do
          if result.success?
            flash[:info] = result.flash
            redirect_to root_path
          else
            flash[:warning] = result.flash
            redirect_to member_dashboard_path
          end
        end

        format.json { render :json => result.response }
      end
    end
    #endregion

    #region Member
    def dash
      redirect_to setup_path unless current_member.configured?

      DiabeticToolbox.from :members, require: %w(member_dashboard)

      @chart_data = MemberDashboard.history current_member unless current_member.has_no_readings?
      @library    = MemberDashboard.chartkick_library unless current_member.has_no_readings?
    end
    #endregion

    #region Private
    private
      def member_params
        params.require(:member).permit(:first_name, :last_name, :username, :email, :password, :password_confirmation, :dob, :gender, :accepted_tos)
      end

      def set_member
        @member = current_member
      end

      def there_can_be_only_one
        @ensure_cohesion = true
      end

      def sign_in_new_member
        session = DiabeticToolbox::MemberSession.new( request.env['REMOTE_ADDR'], {'email' => member_params[:email], 'password' => member_params[:password]} )
        member  = session.create

        begin_arbitrary_session(member) if session.in_progress?
      end
    #endregion
  end
end
