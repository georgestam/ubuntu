class StatsController < ApplicationController
  def index
    policy_scope(User)  
    @data = Alert.all.group(:type_alert)  
  end
  
end
