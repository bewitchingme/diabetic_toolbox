module DiabeticToolbox
  class Recipe < ActiveRecord::Base
    include DiabeticToolbox::Concerns::Voteable

    belongs_to :member,      class_name: 'DiabeticToolbox::Member',    counter_cache: true
    has_many   :ingredients, class_name: 'DiabeticToolbox::Ingredient'
    has_many   :steps,       class_name: 'DiabeticToolbox::Step'
  end
end
