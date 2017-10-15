class UsagesController < ApplicationController
  
  before_action :load_dates
  before_action :skip_authorization, only: %i[total_usage_and_custommer_with_usage_per_day custommer_with_usage_per_week]
  
  def total_usage_and_custommer_with_usage_per_day
  end 
  
  def custommer_with_usage_per_week
  end 
  
  private
  
  def load_dates
    @start_date = session[:start_date].to_datetime.midnight
    @end_date = session[:end_date].to_datetime.at_end_of_day
  end  

end
