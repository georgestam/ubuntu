class SendDailyRemindersToSlackJob < ApplicationJob
  queue_as :default

  def perform(*args)
    logger.info { "I'm starting jobs" } 
    if development_or_test?
      Alert.notify_open_alerts_to_slack(User.find_by(slack_username: "@jordi"))
    elsif 
      User.all.each do |user|
        Alert.notify_open_alerts_to_slack(user)
      end
    end  
    logger.info { "OK I'm done now" }
  end
end
