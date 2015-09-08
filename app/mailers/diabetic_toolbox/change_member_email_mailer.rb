module DiabeticToolbox
  class ChangeMemberEmailMailer < ApplicationMailer
    def send_confirmation_link(member)
      @member = member
    end
  end
end
