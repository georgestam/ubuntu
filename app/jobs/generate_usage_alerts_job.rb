class GenerateUsageAlertsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Alert.check_meters_exceeding_max_daily_usage
  end
end
