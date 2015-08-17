require 'faker'

module DiabeticToolbox
  FactoryGirl.define do
    factory :setting, class: DiabeticToolbox::Setting do |setting|
      setting.intake_ratio 10
      setting.correction_begins_at 7
      setting.increments_per 2
      setting.ll_units_per_day 18
      setting.glucometer_measure_type :mmol
      setting.intake_measure_type :carbohydrates
    end
  end
end