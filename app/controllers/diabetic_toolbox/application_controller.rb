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

    protected
      def deploy_member_tabs
        @tabs = {
            :dashboard  => [I18n.t('navigation.members.dashboard'),  'dashboard', member_dash_path(current_member)],
            :readings   => [I18n.t('navigation.members.readings'),   'book',      '#'],
            :reports    => [I18n.t('navigation.members.reports'),    'bar-chart', '#'],
            :recipes    => [I18n.t('navigation.members.recipes'),    'list',      '#'],
            :meal_plans => [I18n.t('navigation.members.meal_plans'), 'road',      '#']
        }
      end

    private
      def initialize_member_session
        @current_member ||= DiabeticToolbox::Members::Session.find session[:session_token] if session[:session_token].present?
      end
  end
end
