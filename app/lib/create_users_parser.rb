class CreateUsersParser
  
  require 'rest-client'
  
  def self.update_users_db
    url1 = "https://api.steama.co/customers/?format=json&page_size=100"
    url2 = "https://api.steama.co/customers/?format=json&page=2&page_size=100"
    
    [url1,url2].each do |url|
      body = RestClient.get url, {:Authorization => "Token #{ENV['TOKEN_STEAMA']}"}
      json_data = JSON.parse(body)
      # This defines the id:
      # body['results'][0]['id']
      
      # json_data['results']each do |user|
      #   unless false # exist > user['id']
      #     create_new_user(user)  
      # end 
      # binding.pry
      CreateUsersParser.create_new_customer(json_data['results'][0])  
    end 
  
  end
  
  def self.create_new_customer(user)
    if Customer.create!({  
        id_steama: user['id'],
        url: user['url'],
        transactions_url: user['transactions_url'],
        utilities: user['utilities'],
        telephone: user['telephone'], 
        first_name: user['first_name'],
        last_name: user['last_name'],
        account_balance: user['account_balance'],
        low_balance_warning: user['low_balance_warning'],
        low_balance_level: user['low_balance_level'],
        site_manager: user['site_manager'], 
        site_manager_url: user['site_manager_url'],
        site_manager_telephone: user['site_manager_telephone'],
        site: user['site'],
        site_url: user['site_url'],
        site_name: user['site_name'],
        bit_harvester: user['bit_harvester'],
        bit_harvester_url: user['bit_harvester_url'],
        bit_harvester_telephone: user['bit_harvester_telephone'],
        control_type: user['control_type'], 
        line_number: user['line_number'],
        is_user: user['is_user'],
        is_agent: user['is_agent'],
        is_site_manager: user['is_site_manager'],
        is_field_manager: user['is_field_manager'],
        is_demo: user['is_demo'],
        language: user['language'],
        TOU_hours: user['TOU_hours'],
        payment_plan: user['payment_plan'],
        integration_id: user['integration_id'],
        labels: user['labels']
        })
    else 
      #todo: send email with there has been a problem
    end 
         
  end 
  
end