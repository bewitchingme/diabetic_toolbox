module DiabeticToolbox
  FactoryGirl.define do
    factory :nutritional_fact, class: NutritionalFact do
      recipe   nil
      nutrient :nutrient
      quantity 35
      verified false
    end
  end
end