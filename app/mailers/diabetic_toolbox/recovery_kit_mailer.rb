module DiabeticToolbox
  class RecoveryKitMailer < ApplicationMailer
    def send_forgot_password_kit(member)
      @member = member

    end
  end
end
