module DiabeticToolbox
  class Recipe < ActiveRecord::Base
    acts_as_votable
    belongs_to :member,      class_name: 'DiabeticToolbox::Member'
    has_many   :ingredients, class_name: 'DiabeticToolbox::Ingredient'
  end
end
