class StatsController < ApplicationController
  
  def index
    policy_scope(User)
  end
  
  def montly_graphs
    skip_authorization
  end 
  
end
