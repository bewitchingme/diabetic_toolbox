require_dependency "diabetic_toolbox/application_controller"

module DiabeticToolbox
  class WelcomeController < DiabeticToolbox::ApplicationController
    def start
      redirect_to member_dash_path(current_member) if member_signed_in?
    end
  end
end
