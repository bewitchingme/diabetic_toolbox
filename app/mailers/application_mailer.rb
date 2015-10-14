#:enddoc:
class ApplicationMailer < ActionMailer::Base
  default from: DiabeticToolbox.mailer_from_address
  layout 'mailer'
end
