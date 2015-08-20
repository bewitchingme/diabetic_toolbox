module DiabeticToolbox
  class ApplicationController < ActionController::Base
    #region Session
    before_action :initialize_member_session
    #endregion

    #region Helpers
    helper_method :current_member, :member_signed_in?
    #endregion

    #region Protected
    protected
    #region Member Authentication
    def current_member
      @current_member
    end

    def instant_in(member, scope = :diabetic_toolbox__member)
      request.env['warden'].set_user( member, scope: scope )
    end

    def member_signed_in?
      @current_member.present?
    end
    #endregion

    #region Authorization
    def current_ability
      @current_ability
    end
    #endregion

    #region Navigation
    def deploy_member_tabs
      @tabs = {
          :dashboard  => [I18n.t('navigation.members.dashboard'),  'dashboard', member_dashboard_path(current_member)],
          :readings   => [I18n.t('navigation.members.readings'),   'book',      '#'],
          :reports    => [I18n.t('navigation.members.reports'),    'bar-chart', '#'],
          :recipes    => [I18n.t('navigation.members.recipes'),    'list',      '#'],
          :meal_plans => [I18n.t('navigation.members.meal_plans'), 'road',      '#']
      }
    end
    #endregion

    #region Member Checks
    def member_configured?
      redirect_to setup_path if current_member.present? && current_member.settings.size.eql?(0)
    end
    #endregion
    #endregion

    #region Private
    private
    #region Authentication
    def initialize_member_session
      @current_member  ||= request.env['warden'].user :diabetic_toolbox__member
      @current_ability = DiabeticToolbox::MemberAbility.new @current_member
    end
    #endregion

    #region Locale
    def set_locale
      I18n.default_locale = :en
    end
    #endregion
    #endregion
  end
end
