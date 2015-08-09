module DiabeticToolbox
  class Member < ActiveRecord::Base
    include DiabeticToolbox::Concerns::Authenticatable
    include DiabeticToolbox::Concerns::Voter

    has_karma 'DiabeticToolbox::Recipe', as: :member, weight: 0.5

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

    has_many :settings,              class_name: 'DiabeticToolbox::Setting'
    has_many :readings,              class_name: 'DiabeticToolbox::Reading'
    has_many :report_configurations, class_name: 'DiabeticToolbox::ReportConfiguration'
    has_many :reports,               class_name: 'DiabeticToolbox::Report'
    has_many :recipes,               class_name: 'DiabeticToolbox::Recipe'
    has_many :achievements,          class_name: 'DiabeticToolbox::Achievement'

  end
end
