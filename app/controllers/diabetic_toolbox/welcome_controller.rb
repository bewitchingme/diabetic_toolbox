require_dependency 'diabetic_toolbox/application_controller'

module DiabeticToolbox
  #:enddoc:
  class WelcomeController < ApplicationController
    #region Class Methods
    load_and_authorize_resource class: false
    #endregion

    #region Static Pages Only
    def start
      redirect_to member_dashboard_path if member_signed_in?
    end

    def about
    end
    #endregion
  end
end
