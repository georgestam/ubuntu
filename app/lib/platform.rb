require 'mail'

class Platform
  
  class << self
    
    def name
      "Voiceable"
    end
    
    def telephone
      ""
    end
    
    def address
      "London"
    end
    
    def email
      Mail::Address.new('info@Voiceable.com').tap{|address| address.display_name = name }.format
    end
    
    def notifications_origin_email
      email
    end
    
    def notifications_destination_email
      email
    end
    
    def city
      "London"
    end
    
  end
  
end