module DiabeticToolbox
  class NutritionalFact < ActiveRecord::Base
    belongs_to :recipe, class_name: 'DiabeticToolbox::Recipe'
  end
end
