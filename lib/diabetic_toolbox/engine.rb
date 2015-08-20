require 'warden'

module DiabeticToolbox
  class Engine < ::Rails::Engine
    isolate_namespace DiabeticToolbox

    config.generators do |g|
      g.test_framework    :rspec, fixture: false
      g.template_engine   :haml
      g.stylesheet_engine :scss
      g.javascript_engine :coffee
    end

    %w( members member_sessions settings welcome ).each do |controller|
      config.assets.precompile += ["diabetic_toolbox/#{controller}.css"]
    end

    config.middleware.use Warden::Manager do |config|
      config.failure_app        = DiabeticToolbox::UnauthorizedController
      config.default_scope      = :diabetic_toolbox__member
      config.intercept_401      = :false

      config.scope_defaults :diabetic_toolbox__member, strategies: [:standard]
    end

    Warden::Manager.serialize_from_session(:diabetic_toolbox__member) do |token|
      DiabeticToolbox::Member.find_by_session_token token
    end

    Warden::Manager.serialize_into_session(:diabetic_toolbox__member) do |member|
      member.session_token
    end
  end
end
