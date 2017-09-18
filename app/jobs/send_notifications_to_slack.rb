class SendNotificationsToSlack < ApplicationJob

  queue_as :default

  def initialize(slack_notifier)
    @slack_notifier = slack_notifier
  end

  def perform(alert_id)
    logger.info { "I'm starting jobs" } 
    Alert.slack_api_call(alert_id)
    logger.info { "OK I'm done now" }
  end
end
