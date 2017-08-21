class AlertsController < ApplicationController
  
  def new 
    authorize(current_user)
    @customers = Customer.all
    @type_alerts = TypeAlert.all
    @status = Status.all
  end 
  
  def create 
    @alert = Alert.new(alert_params)
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
    params.require(:alert).permit(:type_alert, :description, :status, :created_by )
  end
  
end

