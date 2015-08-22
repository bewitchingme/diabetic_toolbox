module DiabeticToolbox
  module SettingsHelper
    def glucometer_options(setting)
      options = DiabeticToolbox::Setting.glucometer_options
      if setting.id
        options_for_select options, selected: setting.glucometer_measure_type
      else
        options_for_select options
      end
    end

    def intake_options(setting)
      options = DiabeticToolbox::Setting.intake_options
      if setting.id
        options_for_select options, selected: setting.intake_measure_type
      else
        options_for_select options
      end
    end

    def bootstrap_addon_intake(setting)
      unless setting.new_record?
        return t('views.settings.carbohydrates') if setting.intake_measure_type.to_sym.eql? :carbohydrates
        return t('views.settings.calories') if setting.intake_measure_type.to_sym.eql? :calories
      end
    end

    def bootstrap_addon_glucometer(setting, addon_for_increment = false)
      unless setting.new_record?
        return t('views.settings.mmol') if setting.mmol? && !addon_for_increment
        return t('views.settings.mmol_units') if setting.mmol? && addon_for_increment
        return t('views.settings.mg') if setting.mg? && !addon_for_increment
        return t('views.settings.mg_units') if setting.mg? && addon_for_increment
      end
    end
  end
end
