module DiabeticToolbox
  class Reading < ActiveRecord::Base
    belongs_to :member, class_name: 'DiabeticToolbox::Member'
  end
end
