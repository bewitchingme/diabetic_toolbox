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

module DiabeticToolbox
  def self.from(scope, options)
    if options.has_key? :require
      options[:require].each do |requirement|
        require "#{Engine.root}/app/actions/diabetic_toolbox/#{scope.to_s}/#{requirement}"
      end
    end
  end
end
