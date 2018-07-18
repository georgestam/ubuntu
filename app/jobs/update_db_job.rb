class UpdateDbJob < ApplicationJob
  queue_as :default

  def perform(*args)
    logger.info { "I'm starting jobs" } 
    Customer.update_customer_db
    Balance.update_balance
    # Alert.check_customers_with_negative_acount
    logger.info { "OK I'm done now" }
  end
end