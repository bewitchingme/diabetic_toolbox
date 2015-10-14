module DiabeticToolbox
  #:enddoc:
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
  end
end
