class StatsController < ApplicationController
  
  def index
    policy_scope(User)
    
    customer = Customer.first   
    # data = JSON.parse(self.data)
  end
  
end
