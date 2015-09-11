module DiabeticToolbox
  rely_on :action

  class ReleaseMember < Action
    #region Init
    def initialize(token, release_params)
      super release_params
      @member = Member.find_by_reset_password_token token
    end
    #endregion

    #region Protected
    protected
    def _call
      if @member.update update_params
        success do |option|
          option.subject = @member
          option.message = I18n.t('flash.authenticatable.release.success')
        end
      else
        failure do |option|
          option.subject = @member
          option.message = I18n.t('flash.authenticatable.release.failure')
        end
      end
    end
    #endregion

    #region Private
    private
    def update_params
      {password: @params[:password], password_confirmation: @params[:password_confirmation], reset_password_token: nil, reset_password_sent_at: nil}
    end
    #endregion
  end
end