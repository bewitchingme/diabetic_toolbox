require_dependency "diabetic_toolbox/application_controller"

module DiabeticToolbox
  class ReadingsController < ApplicationController
    #region Class Methods
    load_and_authorize_resource
    respond_to :json, :html
    #endregion

    #region Before Action
    before_action :set_reading, only: [:new]
    before_action :set_current_setting
    before_action :deploy_member_tabs, only: [:index, :new]
    #endregion

    #region Read
    def index
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

    def set_current_setting
      @current_setting = current_member.settings.last
    end
    #endregion
  end
end
