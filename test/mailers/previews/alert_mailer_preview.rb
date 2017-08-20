#  localhost:3000/rails/mailers/alert_mailer/perform
class AlertMailerPreview < ActionMailer::Preview
  def perform
    alert = Alert.first
    AlertMailer.perform(alert)
  end
end