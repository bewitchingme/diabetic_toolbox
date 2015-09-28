module Web
  class Application
    ActionView::Base.default_form_builder = DiabeticToolbox::StandardFormBuilder
  end
end