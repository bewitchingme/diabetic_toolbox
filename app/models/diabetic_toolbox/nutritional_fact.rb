module DiabeticToolbox
  class NutritionalFact < ActiveRecord::Base
    belongs_to :recipe, class_name: 'DiabeticToolbox::Recipe', counter_cache: true

    validates :nutrient, inclusion: { in: ReferenceStandard.nutrients.keys.map {|s| s.to_s}, message: I18n.t('activerecord.validations.common.illegal_value') }
    validates :quantity, numericality: { greater_than: 0, message: I18n.t('activerecord.validations.diabetic_toolbox/nutritional_fact.quantity_non_zero') }
    validates :verified, inclusion: { in: [false], message: I18n.t('activerecord.validations.diabetic_toolbox/nutritional_fact.verified_positive_on_create') }, on: :create
  end
end
