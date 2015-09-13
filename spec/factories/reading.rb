module DiabeticToolbox
  FactoryGirl.define do
    # This factory is only for use with a member when we don't care
    # about the contents.
    factory :reading, class: DiabeticToolbox::Reading do |reading|
      reading.glucometer_value Random.rand((5.5)..(7.5))
      reading.test_time Time.now
      reading.meal :before_breakfast
      reading.intake Random.rand(30..75)
    end
  end
end
