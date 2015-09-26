
#region Requirements
require 'warden'
require 'kaminari'
require 'diabetic_toolbox/engine'
require 'sessions/session'
require 'diabetic_toolbox/intake_nutrition'
require 'diabetic_toolbox/reference_standard'
require 'paperclip'
require 'haml'
require 'haml-rails'
require 'bootstrap-sass'
require 'cancancan'
require 'bcrypt'
require 'responders'
require 'font-awesome-sass'
require 'friendly_id'
require 'babosa'
require 'chartkick'
require 'momentjs-rails'
require 'bootstrap3-datetimepicker-rails'
require 'prawn-rails'
require 'jquery-rails'
#endregion

# = DiabeticToolbox
#
# DiabeticToolbox provides some methods to make it simple to require
# each class we want to work with given an individual action and also
# a way to handle dependencies for children implementing DiabeticToolbox::Action
#
#   DiabeticToolbox.from :members, require: %w(create_member) # DiabeticToolbox::CreateMember is required
#   DiabeticToolbox.rely_on :action                           # DiabeticToolbox::Action is required
#
# To ensure that only the fields we want are returned in our responses:
#
#   DiabeticToolbox.safe :model # [:field_one, :field_two]
#
# And a method to calculate the total number of calories given a DiabeticToolbox::IntakeNutrition object:
#
#   intake_nutrition = DiabeticToolbox::IntakeNutrition.new do
#     add :fat, 5
#     add :protein, 5
#     add :carbohydrate, 10
#   end
#
#   DiabeticToolbox.total_calories(intake_nutrition) # => 105
#
# An initializer should be created to set the following values:
#
#   DiabeticToolbox.config do |config|
#     config.mailer_from_address = 'from@example.com' # From address for ActionMailer
#     config.max_attempts        = 3                  # Maximum failed login attempts before lock
#     config.remember_for        = 3.months           # Period of time that 'Remember Me' lasts for
#   end
#
module DiabeticToolbox
  #:enddoc:
  #region Module Fields
  @@me   = :diabetic_toolbox
  @@safe = {
      member: [:first_name, :last_name, :username, :slug],
      reading: [],
      recipe: [:name, :servings],
      ingredient: [:name, :volume, :unit],
      step: [:description, :order],
      nutritional_fact: [:nutrient, :quantity, :verified]
  }
  #endregion

  #region Data Response Safeties
  def self.safe(model)
    @@safe[model]
  end
  #endregion

  #region Granularity for Requirements
  def self.from(scope, options = {})
    if options.has_key? :require
      options[:require].each do |requirement|
        require Engine.root.join 'app', 'actions', @@me.to_s, scope.to_s, requirement
      end
    end
  end

  def self.rely_on(*args)
    if args.length > 0
      args.each do |requirement|
        require Engine.root.join 'app', 'actions', @@me.to_s, requirement.to_s
      end
    end
  end
  #endregion

  #region Calculations
  # http://www.wikihow.com/Convert-Grams-to-Calories
  def self.total_calories(intake_nutrition)
    (intake_nutrition.for(:protein) * 4) + (intake_nutrition.for(:carbohydrate) * 4) + (intake_nutrition.for(:fat) * 9)
  end
  #endregion
end
