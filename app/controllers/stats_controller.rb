class StatsController < ApplicationController
  
  def index
    policy_scope(User)
    
    customer = Customer.first   
    data = customer.meters.first.usages.first.api_data
  end
  
end
