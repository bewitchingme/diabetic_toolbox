module DiabeticToolbox
  class Setting < ActiveRecord::Base
    belongs_to :member, class_name: 'DiabeticToolbox::Member'

    enum glucometer_measure_type: [:mmol, :mg]
    enum intake_measure_type:     [:carbohydrates, :calories]
  end
end
