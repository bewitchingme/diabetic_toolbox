module DiabeticToolbox
  FactoryGirl.define do
    factory :nutritional_fact, class: NutritionalFact do
      sample_nutrient = ReferenceStandard.nutrients.keys.sample
      recipe   nil
      nutrient sample_nutrient
      quantity (ReferenceStandard.value_for(sample_nutrient).to_f / 3.0)
      verified false
    end
  end
end