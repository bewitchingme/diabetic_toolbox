module DiabeticToolbox
  class Reading < ActiveRecord::Base
    belongs_to :member, class_name: 'DiabeticToolbox::Member'

    enum meal: [:breakfast, :lunch, :dinner]
  end
end
