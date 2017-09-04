class AlertsController < ApplicationController
  
  before_action :set_alert, only: %i[select_issue_response select_alert_subgroup select_issue]
  
  def new 
    authorize(current_user)
    @customers = Customer.all.sort_by(&:first_name).collect {|c| [c.name, c.id]}
    @type_alerts = []
    @issues = []
    @group_alerts = GroupAlert.all.collect {|c| [c.title, c.id]}
    @users = User.all.collect {|c| [c.email, c.id]}
  end 
  
  def create
    
    set_issue 
    
    @alert = Alert.new(alert_params)
    @alert.issue = @issue
    
    authorize @alert
    if @alert.save
      @alert.resolved_at = DateTime.current if params[:status] == "Yes"
      @alert.save! if @alert.resolved?
      flash[:notice] = "New Alert Created!"
    else
      flash[:alert] = @alert.errors.full_messages
    end 
    redirect_to new_alert_path
  end 
  
  def select_issue_response
   # ajax 
   @issue = Issue.find(params[:id])
   render json: [@issue]
  end 
  
  def select_alert_subgroup
   # ajax 
   type_alerts = GroupAlert.find(params[:group_alert]).type_alerts.collect {|c| [c.name, c.id]}
   render json: [type_alerts]
  end 
  
  def select_issue
   # ajax 
   issues = TypeAlert.find(params[:type_alert]).issues.collect {|c| [c.name, c.id]}
   render json: [issues]
  end 
  
  private

  def set_alert
    @alert ||= Alert.new
    authorize @alert
  end 
  
  def set_issue
    # if ther is some input for 'new issue' description it creates a new alert and issue
    @issue = if params[:description_new_alert] != ""
      # first record of GroupAlert and TypeAlert is new
      group_alert = GroupAlert.find_by(id: params[:group_alert])
      type_alert = TypeAlert.new(name: params[:description_new_alert], group_alert: group_alert)
      show_errors_and_redirect unless type_alert.save
      
      Issue.new(resolution: params[:resolved_description_new], type_alert: type_alert)  
  
    # if the issue existed but with diferent resolution
    elsif !Issue.find_by(resolution: params[:resolved_description]) && params[:resolved_description] != ""
      Issue.new(type_alert_id: params[:type_alert], resolution: params[:resolved_description])
    
    # if the issue already existed
    else 
      Issue.find(params[:issue])
    end
    show_errors_and_redirect unless @issue.save 
  end 
  
  def alert_params
    params.require(:alert).permit(:customer_id, :created_by)
  end
  
  def show_errors_and_redirect
    flash[:alert] = @alert.errors.full_messages
    redirect_to new_alert_path
  end 
  
end

