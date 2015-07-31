module DiabeticToolbox
  class Member < ActiveRecord::Base
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable, :validatable,
           :confirmable, :lockable, :timeoutable
    acts_as_voter

    has_many :readings,              class_name: 'DiabeticToolbox::Reading'
    has_many :report_configurations, class_name: 'DiabeticToolbox::ReportConfiguration'
    has_many :reports,               class_name: 'DiabeticToolbox::Report'
    has_many :recipes,               class_name: 'DiabeticToolbox::Recipe'
    has_many :achievements,          class_name: 'DiabeticToolbox::Achievement'
  end
end
