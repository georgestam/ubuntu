class PullUsageJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Customer.all.each do |customer| 
      unless customer.meters.any?
        customer.meters.create!(customer: customer)
      end 
      Usage.request_usage_to_api(Date.yesterday, customer.meters.first.id) 
    end 
  end
end
