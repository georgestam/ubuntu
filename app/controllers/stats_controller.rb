class StatsController < ApplicationController
  
  before_action :format_dates
  before_action :skip_authorization, only: %i[create]
  
  def index
    policy_scope(User)
  end
  
  def create 
    @show_usage = params[:include_usage] == "yes" ? true : false
    respond_to do |format|
      format.js
    end
  end 
  
end
