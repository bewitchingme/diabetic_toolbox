module DiabeticToolbox
  # = ReleaseMember
  #
  # A class to release a member from recovery, where release
  # parameters include password and password_confirmation keys.
  #
  #   result = ReleaseMember.new(token, release_params).call
  #
  class ReleaseMember < Exchange
    #:enddoc:
    #region Init
    def initialize(token, release_params)
      super release_params
      @member = Member.find_by_reset_password_token token
    end
    #endregion

    #region Hooks
    hook :default do
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
      {password: call_params[:password], password_confirmation: call_params[:password_confirmation], reset_password_token: nil, reset_password_sent_at: nil}
    end
    #endregion
  end
end