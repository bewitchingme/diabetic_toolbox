module DiabeticToolbox
  class Recipe < ActiveRecord::Base
    #region Includes & Extends
    include DiabeticToolbox::Concerns::Voteable
    #endregion

    #region Validations
    validates :name, presence: { message: I18n.t('activerecord.validations.common.required') },
              length: { in: (4..64), message: I18n.t('activerecord.validations.common.length_range', min: 4, max: 64) }
    validates :servings, presence: { message: I18n.t('activerecord.validations.common.required') },
              numericality: { greater_than: 0, message: I18n.t('activerecord.validations.diabetic_toolbox/recipe.servings_value') }
    #endregion

    #region Associations
    belongs_to :member,            class_name: 'DiabeticToolbox::Member', counter_cache: true
    has_many   :ingredients,       class_name: 'DiabeticToolbox::Ingredient'
    has_many   :steps,             class_name: 'DiabeticToolbox::Step'
    has_many   :nutritional_facts, class_name: 'DiabeticToolbox::NutritionalFact'
    #endregion

    #region Truth or Dare
    def owned_by?(member)
      return true if member_id == member.id
      false
    end
    #endregion
  end
end
