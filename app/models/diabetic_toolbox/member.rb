module DiabeticToolbox
  class Member < ActiveRecord::Base
    #region Includes
    include DiabeticToolbox::Concerns::Authenticatable
    include DiabeticToolbox::Concerns::Voter
    #endregion

    #region Scopes
    scope :males,   -> { where(:gender => self.genders[:male]  ) }
    scope :females, -> { where(:gender => self.genders[:female]) }
    #endregion

    #region Settings & Enums
    has_karma 'DiabeticToolbox::Recipe', as: :member, weight: 0.25
    enum gender: [:male, :female]
    #endregion

    #region Validations
    validates :first_name, presence: { message: I18n.t('activerecord.validations.common.required') },
              length: { in: (1..64), message: I18n.t('activerecord.validations.common.length_range', min: 1, max: 64) },
              format: { with: /\A[a-zA-Z\s]+\Z/, message: I18n.t('activerecord.validations.diabetic_toolbox/member.first_name_format') }
    validates :last_name, presence: { message: I18n.t('activerecord.validations.common.required') },
              length: { in: (1..64), message: I18n.t('activerecord.validations.common.length_range', min: 1, max: 64) },
              format: { with: /\A[a-zA-Z\-]+\Z/, message: I18n.t('activerecord.validations.diabetic_toolbox/member.last_name_format') }
    validates :username, on: :create, presence: { message: I18n.t('activerecord.validations.common.required') },
              length: { in: (4..256), message: I18n.t('activerecord.validations.common.length_range', min: 4, max: 256) },
              format: { with: /\A[a-zA-Z\d\s]+\Z/, message: I18n.t('activerecord.validations.diabetic_toolbox/member.username_format') }
    validates :accepted_tos, on: :create, presence: { message: I18n.t('activerecord.validations.common.required') }
    validate  :dob_is_valid?
    #endregion

    #region Methods for friendly_id
    extend FriendlyId

    friendly_id :username, use: [:slugged, :finders]

    def should_generate_new_friendly_id?
      new_record? || slug.blank?
    end

    def normalize_friendly_id(text)
      text.to_slug.normalize! :transliterations => [:russian, :latin]
    end
    #endregion

    #region Children
    has_many :settings,              class_name: 'DiabeticToolbox::Setting',             dependent: :destroy
    has_many :readings,              class_name: 'DiabeticToolbox::Reading'
    has_many :report_configurations, class_name: 'DiabeticToolbox::ReportConfiguration', dependent: :destroy
    has_many :reports,               class_name: 'DiabeticToolbox::Report',              dependent: :destroy
    has_many :recipes,               class_name: 'DiabeticToolbox::Recipe'
    has_many :achievements,          class_name: 'DiabeticToolbox::Achievement',         dependent: :destroy
    #endregion

    #region In-house cooking
    def dob_is_valid?
      if dob.present? && dob >= 18.years.ago
        errors.add(:dob, I18n.t('activerecord.validations.common.illegal_value'))
      end
    end
    #endregion

    #region Truth or Dare
    def has_no_readings?
      readings.size.eql?(0)
    end

    def has_no_achievements?
      achievements.size.eql?(0)
    end

    def has_no_recipes?
      recipes.size.eql?(0)
    end

    def configured?
      !settings.size.eql?(0)
    end
    #endregion

    #region Enum Representation
    def self.gender_options
      [
        [I18n.t('activerecord.options.diabetic_toolbox/member.male'),   :male],
        [I18n.t('activerecord.options.diabetic_toolbox/member.female'), :female]
      ]
    end
    #endregion
  end
end
