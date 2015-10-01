require_dependency "diabetic_toolbox/application_controller"

module DiabeticToolbox
  class ReadingsController < ApplicationController
    #region Class Methods
    load_and_authorize_resource
    respond_to :json, :html
    #endregion

    #region Before Action
    before_action :set_reading, only: [:new]
    before_action :deploy_member_navigation, only: [:index, :new]
    helper_method :initial_test_time
    #endregion

    #region Read
    def index
      @readings = Reading.where(member_id: current_member.id).order(test_time: :desc).page params[:page]
    end

    def new
    end
    #endregion

    #region Creation
    def create
      DiabeticToolbox.from :readings, require: %w(create_member_reading)

      result = CreateMemberReading.new(current_member, reading_params).call

      if result.success?
        flash[:success] = result.flash
        redirect_to list_readings_path
      else
        deploy_member_navigation
        @reading       = result.actual
        flash[:danger] = result.flash
        render :new
      end
    end
    #endregion

    #region Private
    private
    def reading_params
      params.require(:reading).permit :glucometer_value, :test_time, :meal, :intake
    end

    def set_reading
      @reading = current_member.readings.build
    end

    def initial_test_time
      Time.current.strftime('%Y-%m-%d %I:%M %p')
    end
    #endregion
  end
end
