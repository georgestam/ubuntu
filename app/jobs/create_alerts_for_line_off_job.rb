class CreateAlertsForLineOffJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Alert.create_alert_for_customers_with_line_off
  end
end
