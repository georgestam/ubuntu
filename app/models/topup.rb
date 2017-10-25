class Topup < ApplicationRecord
  belongs_to :customer
  
  validates :customer, presence: true
  validates :id_steama, presence: true
  validates :created_on, presence: true
  validates :reference, presence: true, uniqueness: true
  validates :amount, :numericality => { :greater_than_or_equal_to => 1 }
  
  def self.update_topups_from_api
  
    if test?
      file = Rails.root.join('spec', 'support', 'example_steama.json')
      json_data = JSON.parse(File.read(file))
    else 
      Customer.all.each do |customer|
        url = "https://api.steama.co/customers/#{customer.id_steama}/transactions/?format=json&page_size=70"

        body = RestClient.get url, {:Authorization => "Token #{ENV['TOKEN_STEAMA']}"}
        json_data = JSON.parse(body)
        
        if json_data['results'] # checks that that the customer at least did one topup
          json_data['results'].each do |topup|
            unless Topup.find_by(reference: topup['reference'].to_i)
              Topup.create!({
                  customer: customer,
                  amount: topup["amount"],
                  id_steama: topup["id"],
                  created_on: DateTime.strptime(topup["timestamp"], '%Y-%m-%dT%H:%M:%S%z'),
                  reference: topup["reference"],
                  raw_message: topup["raw_message"]
                  })   
            end      
          end    
        end 
      end        
    end
    
  end
  
end
