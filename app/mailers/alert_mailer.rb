class AlertMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.alert_mailer.perform.subject
  #
  
  
  def perform(alert)
    @greeting = "Hi"
    @alert = alert  # Instance variable => available in view
    @user = User.first

    mail(to: 'jordi@respira.io', subject: 'Welcome to Le Wagon')
    # This will render a view in `app/views/user_mailer`!
  end
end
