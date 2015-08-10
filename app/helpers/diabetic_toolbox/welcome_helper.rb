module DiabeticToolbox
  module WelcomeHelper
    def about_this_toolbox
      render partial: "diabetic_toolbox/welcome/about.#{I18n.locale.to_s}"
    end
  end
end
