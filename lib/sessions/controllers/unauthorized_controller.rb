module DiabeticToolbox
  #:enddoc:
  class UnauthorizedController < ActionController::Metal
    include ActionController::UrlFor
    include ActionController::Redirecting
    include DiabeticToolbox::Engine.routes.url_helpers
    include DiabeticToolbox::Engine.routes.mounted_helpers

    delegate :flash, :to => :request

    def self.call(env)
      @respond ||= action(:respond)
      @respond.call(env)
    end

    def respond
      unless request.get?
        if session.has_key? :result_message
          flash[:danger] = session[:result_message]
          session.delete :result_message
        end
      end

      redirect_to sign_in_path
    end
  end
end