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
  
  private
  
  def format_dates
    @start_date = params[:start_date].blank? ? 2.weeks.ago.midnight : params[:start_date].to_datetime.midnight
    @end_date = params[:end_date].blank? ? Time.current.at_end_of_day : params[:end_date].to_datetime.at_end_of_day
    
    # sessions used into the usage controller
    session[:start_date] = @start_date
    session[:end_date] = @end_date 
  end 
  
end
