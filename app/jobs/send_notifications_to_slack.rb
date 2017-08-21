class SendNotificationsToSlack < ApplicationJob
  queue_as :default

  def perform(alert_id)
    puts "I'm starting jobs"
    Alert.slack_API_call(alert_id)
    puts "OK I'm done now"
  end
end
