DiabeticToolbox.config do |setting|
  setting.mailer_from_address = 'test.account@diabetictoolbox.org'
  setting.max_attempts        = 3
  setting.remember_for        = 3.months.from_now
end