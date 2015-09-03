
#region Requirements
require 'warden'
require 'diabetic_toolbox/engine'
require 'sessions/session'
require 'paperclip'
require 'haml'
require 'haml-rails'
require 'bootstrap-sass'
require 'cancancan'
require 'kaminari'
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

#region DiabeticToolbox
module DiabeticToolbox
  #region Module Fields
  @@me   = :diabetic_toolbox
  @@safe = {
      member: [:first_name, :last_name, :username, :slug]
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
end
#endregion
