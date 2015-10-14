module DiabeticToolbox
  #:enddoc:
  class Achievement < ActiveRecord::Base
    belongs_to :member, class_name: 'DiabeticToolbox::Member', counter_cache: true

    enum level: { copper: 0, silver: 1, gold: 2, platinum: 3, crown: 4 }
  end
end
