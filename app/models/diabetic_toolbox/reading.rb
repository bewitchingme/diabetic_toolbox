module DiabeticToolbox
  class Reading < ActiveRecord::Base
    #region Associations
    belongs_to :member, class_name: 'DiabeticToolbox::Member', counter_cache: true
    #endregion

    #region Enum
    enum meal: {
         before_breakfast: 0,
         after_breakfast:  1,
         before_lunch:     2,
         after_lunch:      3,
         before_dinner:    4,
         after_dinner:     5,
         before_bedtime:   6
    }
    #endregion
  end
end
