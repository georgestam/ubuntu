class Usage < ApplicationRecord
  belongs_to :meter
  
  validates :meter, presence: true
  validates :api_data, presence: true
  
  validates :created_on, uniqueness: {scope: :meter}, allow_nil: true
  
  def self.request_usage_to_api(date, meter_id)
    customer = Meter.find(meter_id).customer
    url = "https://api.steama.co/customers/#{customer.id_steama}/utilities/1/usage/?end_time=2017-09-26&format=json&start_time=2017-09-025T00%3A00%3A00"
    json_data = if !test?  
      body = RestClient.get( url,
      {
       :Authorization => "Token #{ENV['TOKEN_STEAMA']}",
       :start_date => "2017-09-25",
       :end_time => "2017-09-26",
       :headers => { content_type: :json }
      })    
      JSON.parse(body)
    else 
      file = Rails.root.join('spec', 'support', 'example_steama_usage.json')
      JSON.parse(File.read(file))
    end 
    
    usage = Usage.new(api_data: json_data, meter_id: meter_id, created_on: date)
  
    unless usage.save
      #  TODO: send email with error
    end 
  end
  
end
