class RestClientCall
  
  def self.extract_body(url)
    body = ""
    begin
      body = RestClient.get url, {:Authorization => "Token #{ENV['TOKEN_STEAMA']}"}
    rescue RestClient::ExceptionWithResponse => e
      e.response
    end
    body
  end
  
end