class AlertsController < ApplicationController
  
  def new 
    authorize(current_user)
    @customers = Customer.all.sort_by(&:first_name).collect {|c| [c.name, c.id]}
    @type_alerts = []
    @queries= []
    @group_alerts= GroupAlert.all.collect {|c| [c.title, c.id]}
    @users= User.all.collect {|c| [c.email, c.id]}
  end 
  
  def create 
    # if ther is some input for 'new issue' description it creates a new alert and query
    if params[:description_new_alert] != ""
      #firs record of GroupAlert and TypeQuery is new
      group_alert = GroupAlert.find_by(title: "new")
      type_alert = TypeAlert.new(name: params[:description_new_alert], group_alert: group_alert )
      unless type_alert.save
        flash[:alert] = @alert.errors.full_messages
        redirect_to new_alert_path
      end 
      
      @query = Query.new(resolution: params[:resolved_description_new], type_alert: type_alert) 
      unless @query.save
        flash[:alert] = @alert.errors.full_messages
        redirect_to new_alert_path
      end 
  
    # if the issue existed but with diferent resolution
    elsif !Query.find_by(resolution: params[:resolved_description]) && params[:resolved_description] != ""
      @query = Query.new(type_alert_id: params[:type_alert])
      @query.resolution = params[:resolved_description]
      unless @query.save
        flash[:alert] = @alert.errors.full_messages
        redirect_to new_alert_path
      end
    # if the issue already existed
    else 
      @query = Query.find(params[:query])
    end 
    
    @alert = Alert.new(alert_params)
    @alert.query = @query
    
    authorize @alert
    if @alert.save
      @alert.resolved_at! if params[:status] == "Yes"
      flash[:notice] = "New Issue Created!"
    else
      flash[:alert] = @alert.errors.full_messages
    end 
    redirect_to new_alert_path
  end 
  
  def select_issue_response
    # ajax 
   @alert ||= Alert.new
   authorize @alert
   @query = Query.find(params[:id])
   render json: [@query]
  end 
  
  def select_alert_subgroup
    # ajax 
   @alert ||= Alert.new
   authorize @alert
   @group_alert = GroupAlert.find(params[:group_alert])
   @type_alerts = @group_alert.type_alerts.collect {|c| [c.name, c.id]}
   render json: [@type_alerts]
  end 
  
  def select_query
    # ajax 
   @alert ||= Alert.new
   authorize @alert
   @type_alert = TypeAlert.find(params[:type_alert])
   @queries = @type_alert.queries.collect {|c| [c.name, c.id]}
   render json: [@queries]
  end 
  
  private
  
  def alert_params
    params.require(:alert).permit(:customer_id, :created_by)
  end
  
end

