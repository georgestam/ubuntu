class CreateUsersParser
  
  require 'rest-client'
  
  def self.update_users_db
    url1 = "https://api.steama.co/customers/?format=json&page_size=100"
    url2 = "https://api.steama.co/customers/?format=json&page=2&page_size=100"
    
    # body = RestClient.get(url1)
    body = RestClient.get url1, {:Authorization => "Token #{ENV['TOKEN_STEAMA']}"}
    JSON.parse(body)
    raise
  end
  
end