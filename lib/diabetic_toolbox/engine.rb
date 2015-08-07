module DiabeticToolbox
  class Engine < ::Rails::Engine
    isolate_namespace DiabeticToolbox

    config.generators do |g|
      g.template_engine   :haml
      g.stylesheet_engine :sass
      g.javascript_engine :coffee
    end
  end
end
