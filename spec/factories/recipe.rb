module DiabeticToolbox
  FactoryGirl.define do
    factory :brace_of_coneys, class: DiabeticToolbox::Recipe do |recipe|
      recipe.name      'Brace of Coneys'
      recipe.servings  4
      recipe.published false
    end

    factory :recipe, class: DiabeticToolbox::Recipe do |recipe|
      recipe.sequence(:name) { |n| "Foody Food#{n}" }
      recipe.servings Random.rand(1..4)
      recipe.published false

      factory :published_recipe do
        published true
      end
    end
  end
end
