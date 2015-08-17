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

      def current_ability
        @current_ability
      end

      def deploy_member_tabs
        @tabs = {
            :dashboard  => [I18n.t('navigation.members.dashboard'),  'dashboard', member_dashboard_path(current_member)],
            :readings   => [I18n.t('navigation.members.readings'),   'book',      '#'],
            :reports    => [I18n.t('navigation.members.reports'),    'bar-chart', '#'],
            :recipes    => [I18n.t('navigation.members.recipes'),    'list',      '#'],
            :meal_plans => [I18n.t('navigation.members.meal_plans'), 'road',      '#']
        }
      end

      def member_configured?
        redirect_to setup_path if current_member.present? && current_member.settings.size.eql?(0)
      end
    private
      def initialize_member_session
        @current_member  ||= request.env['warden'].user :member
        @current_ability = DiabeticToolbox::MemberAbility.new @current_member
      end
  end
end
