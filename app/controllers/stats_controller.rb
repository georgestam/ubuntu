class StatsController < ApplicationController
  
  before_action :format_dates, only: %i[index create customer_list]
  before_action :load_costumers, only: %i[index create customer_list]
  before_action :skip_authorization, only: %i[create graph_costumer customer_list]
  before_action :load_dates, only: %i[graph_costumer]
  
  def index
    policy_scope(User)
  end
  
  def create 
    @show_usage = params[:include_usage] == "yes" ? true : false
    respond_to do |format|
      format.js
    end
  end 
  
  def graph_costumer
    @customer = Customer.find(params["customer_id"].to_i)
  end 
  
  def customer_list
    @tariff_1 = Customer.tariff(1).to_i 
    @tariff_2 = Customer.tariff(2).to_i
    @tariff_2 = Customer.tariff(3).to_i 
  end 
  
  private
  
  def load_costumers
    @customers = Customer.all.sort_by(&:first_name).collect {|c| [c.name, c.id]}
  end
  
  def format_dates
    @start_date = params[:start_date].blank? ? 2.weeks.ago.midnight : params[:start_date].to_datetime.midnight
    @end_date = params[:end_date].blank? ? Time.current.at_end_of_day : params[:end_date].to_datetime.at_end_of_day
    
    # sessions used into the usage controller
    session[:start_date] = @start_date
    session[:end_date] = @end_date 
  end 
  
end
