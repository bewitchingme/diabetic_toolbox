require 'warden'

module DiabeticToolbox
  class Engine < ::Rails::Engine
    isolate_namespace DiabeticToolbox
    config.action_dispatch.rescue_responses.merge! 'CanCan::AccessDenied' => :forbidden

    config.generators do |g|
      g.test_framework      :rspec,        fixture: false
      g.fixture_replacement :factory_girl, dir:     'spec/factories'
      g.template_engine     :haml
      g.stylesheet_engine   :scss
      g.javascript_engine   :coffee
    end

    %w( members member_sessions settings welcome readings ).each do |controller|
      config.assets.precompile += ["diabetic_toolbox/#{controller}.css"]
    end

    config.middleware.use Warden::Manager do |config|
      config.failure_app    = UnauthorizedController
      config.default_scope  = :diabetic_toolbox__member
      config.intercept_401  = :false
      config.scope_defaults   :diabetic_toolbox__member, strategies: [:member]
    end

    Warden::Manager.serialize_from_session(:diabetic_toolbox__member) do |token|
      DiabeticToolbox::MemberSession.find token
    end

    Warden::Manager.serialize_into_session(:diabetic_toolbox__member) do |member|
      member.session_token
    end
  end

  mattr_accessor :mailer_from_address, :max_attempts, :remember_for

  def self.config
    yield self
  end
end
