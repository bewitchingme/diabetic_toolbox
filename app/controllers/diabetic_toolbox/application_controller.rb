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

    def begin_arbitrary_session(member, scope = :diabetic_toolbox__member)
      request.env['warden'].set_user( member, scope: scope )
    end

    def sign_in!(scope = :diabetic_toolbox__member)
      request.env['warden'].authenticate! scope: :diabetic_toolbox__member
    end

    def sign_out(scope = :diabetic_toolbox__member)
      cookies.delete :remembrance_token
      request.env['warden'].logout scope
    end

    def authenticated?(scope = :diabetic_toolbox__member)
      request.env['warden'].authenticated? scope: scope
    end

    def member_signed_in?
      @current_member.present? && authenticated?
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
          :summary    => [I18n.t('navigation.members.summary'),    'thumb-tack', member_dashboard_path],
          :readings   => [I18n.t('navigation.members.readings'),   'book',       '#'],
          :reports    => [I18n.t('navigation.members.reports'),    'bar-chart',  '#'],
          :recipes    => [I18n.t('navigation.members.recipes'),    'list',       '#'],
          :meal_plans => [I18n.t('navigation.members.meal_plans'), 'road',       '#']
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
      recall_member
      @current_member  ||= request.env['warden'].user :diabetic_toolbox__member
      @current_ability = MemberAbility.new @current_member
    end

    def recall_member
      if cookies.has_key? :remembrance_token
        @current_member = Member.find_by_remembrance_token cookies[:remembrance_token]
        begin_arbitrary_session @current_member if @current_member.present?
      end
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
