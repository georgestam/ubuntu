class StatsController < ApplicationController
  
  def index
    policy_scope(User)
    
    # [{:name=>"Created Alerts", :data=>{Sun, 24 Sep 2017=>3}}, {:name=>"Resolved Alerts", :data=>{}}]
    
    customer = Customer.first 
    @data = [] 
    json = JSON.parse(customer.meters.first.usages.first.api_data)
    json.each do |usage|
      
    end 
    
  end
  
end
