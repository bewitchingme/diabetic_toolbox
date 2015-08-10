module DiabeticToolbox
  module SettingsHelper
    def glucometer_options(setting)
      options = DiabeticToolbox::Setting.glucometer_measure_types.keys.map { |key| [key.to_s.titlecase, key] }
      if setting.id
        options_for_select options, selected: setting.glucometer_measure_type
      else
        options_for_select options
      end
    end

    def intake_options(setting)
      options = DiabeticToolbox::Setting.intake_measure_types.keys.map { |key| [key.to_s.titlecase, key] }
      if setting.id
        options_for_select options, selected: setting.intake_measure_type
      else
        options_for_select options
      end
    end

    def bootstrap_addon_intake(setting)
      unless setting.new_record?
        return t('views.settings.carbohydrates') if setting.intake_measure_type.to_sym.eql? :carbohydrates
        return t('views.settings.calories') if setting.intake_measure_type.eql? :calories
      end
    end

    def bootstrap_addon_glucometer(setting)
      unless setting.new_record?
        return t('views.settings.mmol') if setting.glucometer_measure_type.to_sym.eql? :mmol
        return t('views.settings.mg') if setting.glucometer_measure_type.to_sym.eql? :mg
      end
    end
  end
end
