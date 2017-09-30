class StatsController < ApplicationController
  
  def index
    policy_scope(User)
    
    # [{:name=>"Created Alerts", :data=>{Sun, 24 Sep 2017=>3}}, {:name=>"Resolved Alerts", :data=>{}}]
    
  end
  
end
