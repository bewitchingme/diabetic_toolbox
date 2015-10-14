require_dependency 'diabetic_toolbox/application_controller'

module DiabeticToolbox
  #:enddoc:
  class WelcomeController < DiabeticToolbox::ApplicationController
    load_and_authorize_resource class: false

    def start
      redirect_to member_dashboard_path if member_signed_in?
    end

    def about

    end
  end
end
