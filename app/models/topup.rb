class Topup < ApplicationRecord
  belongs_to :customer
  
  validates :customer, presence: true
  validates :id_steama, presence: true, uniqueness: true
  validates :created_on, presence: true
  validates :reference, presence: true, uniqueness: true
  validates :amount, :numericality => { :greater_than_or_equal_to => 1 }
  
  def self.update_topups_from_api
    if test?
      file = Rails.root.join('spec', 'support', 'example_steama_topups.json')
      json_data = JSON.parse(File.read(file))
      Topup.create_topup_from_api(json_data, Customer.first)
    else 
      Customer.all.each do |customer|
        url = "https://api.steama.co/customers/#{customer.id_steama}/transactions/?format=json&page_size=70" 
        body = RestClientCall.get_body
        json_data = JSON.parse(body) if body != ""
        Topup.create_topup_from_api(json_data, customer) if json_data['results'].any? # checks that that the customer at least did one topup
      end       
    end
    
  end
  
  def self.create_topup_from_api(json_data, customer)
    json_data['results'].each do |topup|
      unless Topup.find_by(reference: topup['reference'])
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
