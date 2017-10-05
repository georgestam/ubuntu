class Usage < ApplicationRecord
  
  require 'rest-client'
  
  belongs_to :meter
  
  validates :meter, presence: true
  validates :api_data, presence: true
  
  validates :created_on, uniqueness: {scope: :meter}, allow_nil: true
  
  def self.max_usage_per_customer 
    solar_system_capacity = 50 # kwh
    (solar_system_capacity.to_f / Customer.count)
  end 
  
  def self.request_usage_to_api(start_time, meter_id)
    end_time = start_time + 1
    customer = Meter.find(meter_id).customer
    url = "https://api.steama.co/customers/#{customer.id_steama}/utilities/1/usage/?end_time=#{end_time}&format=json&start_time=#{start_time}"
    json_data = if !test?  
      RestClient.get url, {:Authorization => "Token #{ENV['TOKEN_STEAMA']}"}
    else 
      Rails.root.join('spec', 'support', 'example_steama_usage.json')
    end 
    
    usage = Usage.new(api_data: json_data, meter_id: meter_id, created_on: start_time)
  
    unless usage.save!
      #  TODO: send email with error
    end 
  end
  
  def self.generate_usage_json(meter)
    raw_data = meter.usages.where(created_on: Date.yesterday)[0].try(:api_data)
    if raw_data
      test? ? JSON.parse(File.read(raw_data)) : JSON.parse(raw_data)
    else 
      []
    end
  end
  
end
