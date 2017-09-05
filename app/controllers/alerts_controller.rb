class AlertsController < ApplicationController
  
  def new 
    authorize(Alert.new)
    @customers = Customer.all.sort_by(&:first_name).collect {|c| [c.name, c.id]}
    @type_alerts = TypeAlert.all.collect {|c| [c.name, c.id]}
    @status = Status.all.collect {|c| [c.name, c.id]}
  end 
  
  def create 
    @alert = Alert.new(alert_params)
    authorize @alert
    if @alert.save
      flash[:notice] = "New Issue Created!"
    else
      flash[:alert] = @alert.errors.full_messages
    end 
    redirect_to new_alert_path
  end 
  
  private
  
  def alert_params
    params.require(:alert).permit(:description, :created_by, :type_alert_id, :status_id, :customer_id, :assigned_to, :resolved_comments)
  end
  
end

