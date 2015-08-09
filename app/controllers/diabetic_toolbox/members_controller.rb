require_dependency "diabetic_toolbox/application_controller"

module DiabeticToolbox
  class MembersController < DiabeticToolbox::ApplicationController
    respond_to :html, :json

    #region Before Action
    before_action :deploy_member_tabs, only: :dash
    before_action :set_member, only: [:show, :edit, :update, :destroy]
    #endregion

    #region Creation
    def new
    end

    def create
      create_member = DiabeticToolbox::Members::CreateMember.new( member_params ).call
      @member       = create_member.actual

      respond_to do |format|
        if create_member.successful?
          format.html {
            flash[:result] = create_member.flash
            redirect_to member_path(@member)
          }
          format.json {
            render :json => create_member.response
          }
        else
          format.html {
            flash[:result] = create_member.flash
            redirect_to :new
          }
          format.json {
            render :json => create_member.response
          }
        end
      end
    end
    #endregion

    #region Read
    def show
    end

    def edit
    end
    #endregion

    #region Mutation
    def update
    end

    def destroy
    end
    #endregion

    #region Member
    def dash
      @chart_data = DiabeticToolbox::Members::Dashboard.history current_member
      @library    = DiabeticToolbox::Members::Dashboard.chartkick_library
    end
    #endregion

    #region Private
    private
      def member_params
        params.require(:member).permit(:first_name, :last_name, :username, :email, :password, :password_confirmation, :dob)
      end

      def set_member
        @member = current_member
      end
    #endregion
  end
end
