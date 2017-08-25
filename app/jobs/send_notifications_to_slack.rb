class SendNotificationsToSlack < ApplicationJob
  queue_as :default

  def perform(alert_id)
    logger.info { "I'm starting jobs" } 
    Alert.slack_API_call(alert_id)
    logger.info { "OK I'm done now" }
  end
end
