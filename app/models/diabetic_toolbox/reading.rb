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

    #region Validations
    validates :glucometer_value, presence: { message: I18n.t('activerecord.validations.common.required') }
    validates :test_time, presence: { message: I18n.t('activerecord.validations.common.required') }
    validates :meal, presence: { message: I18n.t('activerecord.validations.common.required') },
              inclusion: { in: self.meals, message: I18n.t('activerecord.validations.common.illegal_value') }
    validates :intake, presence: { message: I18n.t('activerecord.validations.common.required') }
    #endregion

    #region Select Options
    def self.meal_options
      options = []
      self.meals.each do |k,v|
        options.push [I18n.t("views.readings.common.meal_options.#{k.to_s}"), k]
      end
      options
    end
    #endregion
  end
end
