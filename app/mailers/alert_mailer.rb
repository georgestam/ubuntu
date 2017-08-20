class AlertMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.alert_mailer.perform.subject
  #
  
  
  def perform(alert)
    @alert = alert  # Instance variable => available in view

    mail(to: 'jordi@respira.io', subject: 'New Alert')
    # This will render a view in `app/views/user_mailer`!
  end
end
