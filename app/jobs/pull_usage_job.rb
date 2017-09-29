class PullUsageJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Meter.all.each do |meter| 
      Usage.request_usage_to_api(Date.today, meter.id)
    end 
  end
end
