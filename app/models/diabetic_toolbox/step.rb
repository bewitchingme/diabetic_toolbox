module DiabeticToolbox
  class Step < ActiveRecord::Base
    belongs_to :recipe, class_name: 'DiabeticToolbox::Recipe', counter_cache: true
  end
end
