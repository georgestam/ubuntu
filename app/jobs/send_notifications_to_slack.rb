class SendNotificationsToSlack < ApplicationJob
  queue_as :default

  def perform(alert_id)
    logger.info { "I'm starting jobs" } 
    Alert.notify_an_alert_to_slack(alert_id)
    logger.info { "OK I'm done now" }
  end
end
