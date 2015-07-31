module DiabeticToolbox
  class Achievement < ActiveRecord::Base
    belongs_to :member, class_name: 'DiabeticToolbox::Member'

    enum level: [:copper, :silver, :gold, :platinum, :crown]
  end
end
