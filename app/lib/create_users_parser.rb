class CreateUsersParser
  
  require 'rest-client'
  
  def self.update_customer_db
    url1 = "https://api.steama.co/customers/?format=json&page_size=70"
    url2 = "https://api.steama.co/customers/?format=json&page=2&page_size=70"
    
    [url1, url2].each do |url|
      body = RestClient.get url, {:Authorization => "Token #{ENV['TOKEN_STEAMA']}"}
      json_data = JSON.parse(body)
      # This defines the id:
      # body['results'][0]['id']
      
      # create new customers
      json_data['results'].each do |customer|
        # create new customers
        unless Customer.customer_id_exist?(customer['id'])
          Customer.create_new_customer(customer)
        end 
        # update customers
        Customer.find_by(id_steama: customer['id']).update_customer(customer)
      end 
        
    end 
  end
  
end