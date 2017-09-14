class AlertsController < ApplicationController

  before_action :set_alert, only: %i[select_issue_response select_alert_subgroup select_issue]

  def new
    authorize(Alert.new)
    @customers = Customer.all.sort_by(&:first_name).collect {|c| [c.name, c.id]}
    @type_alerts = []
    @issues = []
    @group_alerts = GroupAlert.all.collect {|c| [c.title, c.id]}
    @users = User.all
  end

  def create
    set_issue
    @alert = Alert.new(alert_params)
    authorize @alert
    @alert.issue = @issue
    @alert.type_alert = @type_alert || set_type_alert

    if @alert.save
      flash[:notice] = "New issue Created!"
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
      @issue = Issue.new(type_alert: set_type_alert)
      show_errors_and_redirect unless @issue.save
    end
  end

  def set_type_alert
    TypeAlert.find_by(id: params[:type_alert])
  end

  def alert_params
    params.require(:alert).permit(:customer_id, :created_by)
  end

  def show_errors_and_redirect
    flash[:alert] = @alert.errors.full_messages
    redirect_to new_alert_path
  end

end

