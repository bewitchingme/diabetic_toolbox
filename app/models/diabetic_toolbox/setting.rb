module DiabeticToolbox
  class Setting < ActiveRecord::Base
    belongs_to :member, class_name: 'DiabeticToolbox::Member'

    enum glucometer_measure_type: [:mmol, :mg]
    enum intake_measure_type:     [:carbohydrates, :calories]

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
