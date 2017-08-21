class AlertsController < ApplicationController
  
  def new 
    authorize(current_user)
    @customers = Customer.all.sort_by(&:first_name).map(&:custom_label_method)
    @type_alerts = TypeAlert.all
    @status = Status.all
  end 
  
  def create 
    @alert = Alert.new(alert_params)
    
    # assing params. I get an error with those fields not sure why
    @type_alert = TypeAlert.find(params.require(:alert).permit(:type_alert)[:type_alert])
    @status = Status.find(params.require(:alert).permit(:status)[:status])
    @alert.type_alert = @type_alert
    @alert.status = @status
    
    #split name and find customer
    customer = customer_params[:customer].split(",")
    first_name = customer[0]
    last_name = customer[1]
    customer = Customer.find_by(first_name: first_name ,last_name: last_name)
    
    @alert.customer = customer
    authorize @alert
    if @alert.save
      flash[:notice] = "New Issue Created!"
    else
      flash[:alert] = record.errors.full_messages
    end 
    redirect_to new_alert_path
  end 
  
  private
  
  def alert_params
    params.require(:alert).permit(:description, :created_by)
  end
  
  def customer_params
    params.require(:alert).permit(:customer)
  end 
  
end

