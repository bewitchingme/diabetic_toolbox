module DiabeticToolbox
  class Setting < ActiveRecord::Base
    belongs_to :member, class_name: 'DiabeticToolbox::Member', counter_cache: true

    enum glucometer_measure_type: { mmol: 0, mg: 1 }
    enum intake_measure_type:     { carbohydrates: 0, calories: 1 }

    def self.glucometer_options
      [
        [I18n.t('activerecord.options.diabetic_toolbox/setting.mmol'), :mmol],
        [I18n.t('activerecord.options.diabetic_toolbox/setting.mg'), :mg]
      ]
    end

    def self.intake_options
      [
        [I18n.t('activerecord.options.diabetic_toolbox/setting.carbohydrates'), :carbohydrates],
        [I18n.t('activerecord.options.diabetic_toolbox/setting.calories'), :calories]
      ]
    end
  end
end
