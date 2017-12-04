class RestClientCall
  
  def get_body
    body = ""
    begin
      body = RestClient.get url, {:Authorization => "Token #{ENV['TOKEN_STEAMA']}"}
    rescue RestClient::ExceptionWithResponse => e
      e.response
    end
    body
  end
  
end