class AlertsController < ApplicationController
  
  def new 
    authorize(current_user)
    @customers = Customer.all.sort_by(&:first_name).collect {|c| [c.name, c.id]}
    @type_alerts = TypeAlert.all.collect {|c| [c.name, c.id]}
    @status = Status.all.collect {|c| [c.name, c.id]}
    @queries= Query.all.collect {|c| [c.name, c.id]}
    @group_alerts= GroupAlert.all.collect {|c| [c.title, c.id]}
    @users= User.all.collect {|c| [c.email, c.id]}
  end 
  
  def create 
    @alert = Alert.new(alert_params)
    
    # this checks if the alert was resolved when it was created. 
    status = Status.find(alert_params[:status_id])
    if status == Status.second #resolved status
      @alert.resolved_at = Time.current
    end 
    
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
    params.require(:alert).permit(:created_by, :status_id, :customer_id, :assigned_to, :query_id)
  end
  
end

