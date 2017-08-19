class UpdateDbJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts "I'm starting jobs"
    CreateUsersParser.update_customer_db
    Alert.check_customers_with_negative_acount
    puts "OK I'm done now"
  end
end
