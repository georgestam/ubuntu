class UsagesController < ApplicationController
  before_action :format_dates
  before_action :skip_authorization, only: %i[total_usage_and_custommer_with_usage_per_day custommer_with_usage_per_week]
  
  def total_usage_and_custommer_with_usage_per_day
  end 
  
  def custommer_with_usage_per_week
  end  

end
