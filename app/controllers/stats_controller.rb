class StatsController < ApplicationController
  def index
    policy_scope(User)  
  end
  
end
