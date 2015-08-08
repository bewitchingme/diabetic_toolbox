require_dependency "diabetic_toolbox/application_controller"

module DiabeticToolbox
  class MembersController < DiabeticToolbox::ApplicationController
    before_action :deploy_member_tabs, only: :dash

    respond_to :html, :json
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

    def show
    end

    def edit
    end

    def update
    end

    def destroy
    end

    def dash
      @chart_data = DiabeticToolbox::Members::Dashboard.history current_member
      @library    = DiabeticToolbox::Members::Dashboard.chartkick_library
    end

    private
      def member_params
        params.require(:member).permit(:first_name, :last_name, :username, :email, :password, :password_confirmation, :dob)
      end
  end
end
