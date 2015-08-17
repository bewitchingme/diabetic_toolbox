module DiabeticToolbox
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
        flash[:danger] = I18n.t('views.member_sessions.messages.login_failure')
      end

      redirect_to sign_in_path
    end
  end
end