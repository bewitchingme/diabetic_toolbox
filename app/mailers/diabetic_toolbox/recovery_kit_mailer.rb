module DiabeticToolbox
  class RecoveryKitMailer < ApplicationMailer
    require 'mail'

    #region Mailmen
    def send_forgot_password_kit(member)
      @member = member
      mail to: recipient.format, subject: I18n.t('mailers.recovery_kit.subject')
    end
    #endregion

    #region Private
    private
    def recipient
      to = Mail::Address.new @member.email
      to.display_name = "#{@member.first_name} #{@member.last_name}"
      to
    end
    #endregion
  end
end
