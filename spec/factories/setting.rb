module DiabeticToolbox
  FactoryGirl.define do
    # This factory is only for use with a member when we don't care
    # about the contents (for example, a member is not considered to
    # be configured unless it has at least one setting record.)
    factory :setting, class: DiabeticToolbox::Setting do |setting|
      setting.intake_ratio 10.0
      setting.correction_begins_at 7.1
      setting.increments_per 2.0
      setting.ll_units_per_day 18
      setting.glucometer_measure_type :mmol
      setting.intake_measure_type :carbohydrates
    end

    # These factories are for testing actual values and the below are ratios in both
    # measurement systems and should equate to each other given their contexts.
    factory :carbohydrates_mmol_setting, class: DiabeticToolbox::Setting do |setting|
      setting.intake_ratio 10.0
      setting.correction_begins_at 7.1
      setting.increments_per 2.0
      setting.ll_units_per_day 18
      setting.glucometer_measure_type :mmol
      setting.intake_measure_type :carbohydrates
    end

    factory :calories_mg_setting, class: DiabeticToolbox::Setting do |setting|
      setting.intake_ratio 40.0
      setting.correction_begins_at 127.8
      setting.increments_per 36.0
      setting.ll_units_per_day 18
      setting.glucometer_measure_type :mg
      setting.intake_measure_type :calories
    end
  end
end