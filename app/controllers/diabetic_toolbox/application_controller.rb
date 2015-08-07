module DiabeticToolbox
  class ApplicationController < ActionController::Base
    before_action :initialize_member_session

    helper_method :current_member, :member_signed_in?

    protected
      def current_member
        @current_member
      end

      def member_signed_in?
        @current_member.present?
      end

    private
      def initialize_member_session
        @current_member ||= DiabeticToolbox::Members::Session.find session[:session_token]
      end
  end
end
