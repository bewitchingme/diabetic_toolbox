module DiabeticToolbox
  class Engine < ::Rails::Engine
    isolate_namespace DiabeticToolbox

    config.generators do |g|
      g.test_framework    :rspec, fixture: false
      g.template_engine   :haml
      g.stylesheet_engine :sass
      g.javascript_engine :coffee
    end
  end
end
