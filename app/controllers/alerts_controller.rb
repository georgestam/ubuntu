class AlertsController < ApplicationController
  
  def new 
    authorize(current_user)
    @customers = Customer.all.sort_by(&:first_name).collect {|c| [c.name, c.id]}
    @type_alerts = []
    @issues = []
    @group_alerts = GroupAlert.all.collect {|c| [c.title, c.id]}
    @users = User.all.collect {|c| [c.email, c.id]}
  end 
  
  def create 
    # if ther is some input for 'new issue' description it creates a new alert and issue
    if params[:description_new_alert] != ""
      # first record of GroupAlert and TypeQuery is new
      group_alert = GroupAlert.find_by(title: "new")
      type_alert = TypeAlert.new(name: params[:description_new_alert], group_alert: group_alert)
      unless type_alert.save
        flash[:alert] = @alert.errors.full_messages
        redirect_to new_alert_path
      end 
      
      @issue = Issue.new(resolution: params[:resolved_description_new], type_alert: type_alert) 
      unless @issue.save
        flash[:alert] = @alert.errors.full_messages
        redirect_to new_alert_path
      end 
  
    # if the issue existed but with diferent resolution
    elsif !Issue.find_by(resolution: params[:resolved_description]) && params[:resolved_description] != ""
      @issue = Issue.new(type_alert_id: params[:type_alert])
      @issue.resolution = params[:resolved_description]
      unless @issue.save
        flash[:alert] = @alert.errors.full_messages
        redirect_to new_alert_path
      end
    # if the issue already existed
    else 
      @issue = Issue.find(params[:issue])
    end 
    
    @alert = Alert.new(alert_params)
    @alert.issue = @issue
    
    authorize @alert
    if @alert.save
      @alert.resolved_at = Time.now if params[:status] == "Yes"
      @alert.save! if @alert.resolved?
      flash[:notice] = "New Alert Created!"
    else
      flash[:alert] = @alert.errors.full_messages
    end 
    redirect_to new_alert_path
  end 
  
  def select_issue_response
   # ajax 
   @alert ||= Alert.new
   authorize @alert
   @issue = Issue.find(params[:id])
   render json: [@issue]
  end 
  
  def select_alert_subgroup
   # ajax 
   @alert ||= Alert.new
   authorize @alert
   @group_alert = GroupAlert.find(params[:group_alert])
   @type_alerts = @group_alert.type_alerts.collect {|c| [c.name, c.id]}
   render json: [@type_alerts]
  end 
  
  def select_issue
   # ajax 
   @alert ||= Alert.new
   authorize @alert
   @type_alert = TypeAlert.find(params[:type_alert])
   @issues = @type_alert.issues.collect {|c| [c.name, c.id]}
   render json: [@issues]
  end 
  
  private
  
  def alert_params
    params.require(:alert).permit(:customer_id, :created_by)
  end
  
end

