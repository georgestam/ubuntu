class StatsController < ApplicationController
  
  before_action :format_dates
  before_action :skip_authorization, only: %i[monthly_graphs create]
  
  def index
    policy_scope(User)
    
  end
  
  def monthly_graphs
  end 
  
  def create 
    @show_usage = params[:include_usage] == "yes" ? true : false
    @show_topups = params[:include_topups] == "yes" ? true : false
    respond_to do |format|
      format.js
    end
  end 
  
  private
  
  def format_dates
    @start_date = params[:start_date].blank? ? 2.weeks.ago.midnight : params[:start_date].to_datetime.midnight
    @end_date = params[:end_date].blank? ? Time.current.at_end_of_day : params[:end_date].to_datetime.at_end_of_day
  end
  
end
