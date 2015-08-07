module DiabeticToolbox
  class Recipe < ActiveRecord::Base
    include DiabeticToolbox::Concerns::Voteable

    belongs_to :member,      class_name: 'DiabeticToolbox::Member'
    has_many   :ingredients, class_name: 'DiabeticToolbox::Ingredient'
  end
end
