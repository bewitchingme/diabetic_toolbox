module DiabeticToolbox
  class Achievement < ActiveRecord::Base
    belongs_to :member, class_name: 'DiabeticToolbox::Member', counter_cache: true

    enum level: [:copper, :silver, :gold, :platinum, :crown]
  end
end
