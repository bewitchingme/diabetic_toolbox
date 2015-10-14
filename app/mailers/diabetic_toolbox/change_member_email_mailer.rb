#:enddoc:
module DiabeticToolbox
  class ChangeMemberEmailMailer < ApplicationMailer
    require 'mail'

    #region Mailmen
    def send_confirmation_link(member)
      @member = member
      if @member.present?
        mail to: recipient.format, subject: I18n.t('mailers.change_member_email.subject')
      end
    end
    #endregion

    #region Private
    private
    def recipient
      to = Mail::Address.new @member.unconfirmed_email
      to.display_name = "#{@member.first_name} #{@member.last_name}"
      to
    end
    #endregion
  end
end
