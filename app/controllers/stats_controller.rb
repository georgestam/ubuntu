class StatsController < ApplicationController
  
  before_action :format_dates
  before_action :skip_authorization, only: [:monthly_graphs, :create, :by_day]
  
  def index
    policy_scope(User)
    
  end
  
  def monthly_graphs
  end 
  
  def create 
    respond_to do |format|
      format.js
    end
  end 
  
  private
  
  def format_dates
    @start_date = params[:start_date].nil? || params[:start_date].empty? ?
        1.month.ago.midnight :
        params[:start_date].to_datetime.midnight
    @end_date = params[:end_date].nil? || params[:end_date].empty? ?
        Time.current.at_end_of_day :
        params[:end_date].to_datetime.at_end_of_day
    @start_date, @end_date = @end_date, @start_date if @end_date < @start_date
  end
  
end
