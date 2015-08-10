require_dependency 'diabetic_toolbox/application_controller'

class DiabeticToolbox::SettingsController < DiabeticToolbox::ApplicationController
  load_and_authorize_resource
  before_action :set_setting,            only: [:edit, :update]
  before_action :no_settings_configured, only: [:edit, :update]

  def new
    @setting = DiabeticToolbox::Setting.new
  end

  def edit
  end

  def create
    @setting = current_member.settings.new setting_params

    if @setting.save
      flash[:success] = t('flash.setting.created.success')
      redirect_to member_dashboard_path current_member
    else
      flash[:warning] = t('flash.setting.created.failure')
      render :new
    end
  end

  def update
    @next_version    = current_member.settings.new setting_params
    @next_version.id = nil

    if @next_version.save
      flash[:info] = t('flash.setting.updated.success')
      redirect_to settings_path
    else
      flash[:warning] = t('flash.setting.updated.failure')
      render :edit
    end
  end

  private
    def setting_params
      params.require(:setting).permit(:intake_ratio, :correction_base, :increments_by,
                                      :ll_units_per_day, :glucometer_measure_type, :intake_measure_type)
    end

    def set_setting
      @setting = current_member.settings.last
    end

    def no_settings_configured
      redirect_to setup_path if @setting.blank?
    end
end
