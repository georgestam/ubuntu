class AlertsController < ApplicationController

  before_action :set_alert, only: %i[new show update select_issue_response select_alert_subgroup select_issue]
  
  def index
    alerts = policy_scope(Alert)
    @all_open_alerts = alerts.all_open
    @all_resolved_alerts = alerts.all_resolved
    @my_open_alerts = alerts.my_open
    @my_resolved_alerts = alerts.my_resolved
  end 
  
  def new
    @customers = Customer.all.sort_by(&:first_name).collect {|c| [c.name, c.id]}
    @type_alerts = []
    @issues = []
    @group_alerts = GroupAlert.all.collect {|c| [c.title, c.id]} 
  end
  
  def show 
    issue = @alert.issue.present? ? @alert.issue.name : "Select from previous solutions"
    @issues = []
    @issues << [issue, 1]
    @issues << ["Write your own solution", 2]
    # it does not store the object 'issue if it existed already in the array'
    @issues << TypeAlert.find(@alert.type_alert).issues.collect {|c| [c.name, c.id + 3 ] unless issue == c.name}
    # remove 'nil' if exist in array
    @issues = @issues.reject { |c| c[0].nil? }
    @resolved = @alert.resolved? ? ["Yes", "No"] : ["No", "Yes"]
  end 

  def create
    set_issue
    @alert = Alert.new(alert_params)
    authorize @alert
    @alert.issue = @issue
    @alert.type_alert = @type_alert || set_type_alert

    if @alert.save
      flash[:notice] = "New Alert Created!"
    else
      flash[:alert] = @alert.errors.full_messages
    end
    redirect_to new_alert_path
  end
  
  def update
    set_alert
    if alert_params[:issue] == "2" # if the does not exist (collection on 'write your own solution')
      @issue = Issue.new(type_alert: @alert.type_alert, resolution: params[:resolved_description])
    else # if the solution is in the list
      @issue = @alert.issue
    end
    
    if @alert.update_attributes(issue: @issue) && @issue.save
      @alert.resolved! if params[:resolved?] == "Yes"
      flash[:notice] = "Alert #{@alert.id} has been updated!" 
    else
      flash[:alert] = @alert.errors.full_messages || @issue.errors.full_messages
    end  
    redirect_to alerts_path
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
    @alert = params[:id] ? Alert.find(params[:id]) : Alert.new
    authorize @alert
  end

  def set_issue
    # if there is some input for 'new issue' description it creates a new alert and issue
    if params[:description_new_alert] != ""
      # first record of GroupAlert and TypeAlert is new
      group_alert = GroupAlert.find_by(id: params[:group_alert])
      @type_alert = TypeAlert.new(name: params[:description_new_alert], group_alert: group_alert)
      show_errors_and_redirect unless @type_alert.save

      @issue = nil # return nil issue
    elsif params[:issue] != "" # if the solution exist
      @issue = Issue.find(params[:issue])
    else # if the solution is not in the list
      @issue = nil
    end
  end

  def set_type_alert
    TypeAlert.find_by(id: params[:type_alert])
  end

  def alert_params
    params.require(:alert).permit(:customer, :issue)
  end

  def show_errors_and_redirect
    flash[:alert] = @alert.errors.full_messages
    redirect_to new_alert_path
  end

end

