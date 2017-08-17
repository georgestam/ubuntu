require 'devise/orm/active_record'

Devise.setup do |config|
  config.case_insensitive_keys = [:email]
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/
  config.expire_all_remember_me_on_sign_out = true
  config.mailer_sender = "jordi@newwaves.design"
  config.password_length = Rails.env.development? ? 1..72 : 10..255
  config.reconfirmable = true
  config.remember_for = 6.weeks
  config.rememberable_options = {secure: false} # must be non-secure, else flash messages dissapear
  config.reset_password_within = 6.hours
  config.sign_out_via = :get
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 11
  config.strip_whitespace_keys = [:email]
end
