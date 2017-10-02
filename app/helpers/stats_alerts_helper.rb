module StatsAlertsHelper
  
  def stat_by
    # @customer = Customer.includes(:alerts).first
    # @alerts = @customer.alerts
  
    alerts = Alert.all
    line_chart by_day(alerts), basic_opts('Total alerts')
  end
  
  def total_alerts_in_time
    alerts_created = by_day(Alert.all, "created_at")
    alerts_resolved = by_day(Alert.all, "resolved_at")
    
    data = [
      {name: "Created Alerts", data: alerts_created},
      {name: "Resolved Alerts", data: alerts_resolved}
    ]
    column_chart data, id: "total-alerts-in-time", legend: "bottom", xtitle: "weeks", ytitle: "", library: basic_opts('Total alerts')
  end

  def alerts_by_type_alert
    data = Alert.all.joins(:type_alert).group("type_alerts.id").count.map{|type_alert_id, count| [type_alert_id ? truncate_string(TypeAlert.find(type_alert_id).name) : "Unassigned", count] } # https://github.com/ankane/chartkick/issues/19
    bar_chart data, xtitle: "", ytitle: ""
  end
  
  def alerts_by_group_alert
    data = GroupAlert.joins(:alerts).group("group_alerts.title").count
    bar_chart data
  end
  
  def alerts_by_group_alert_donut
    data = GroupAlert.joins(:alerts).group("group_alerts.title").count
    pie_chart data, donut: true, legend: "bottom"
  end
  
  def alerts_by_time
  data = GroupAlert.all.map { |group_alert| 
    {name: group_alert.title, data: group_alert.alerts.group_by_week("alerts.created_at").count} 
  }
  column_chart data, legend: "bottom", xtitle: "weeks", ytitle: ""
  end 
  
  def top_10_solutions
    
    data = Alert.all_resolved.joins(:issue).group("issues.id").count.map{|issue_id, count| [issue_id ? truncate_string(Issue.find(issue_id).name) : "Unassigned", count] } # https://github.com/ankane/chartkick/issues/19
    top_10_data = data.sort {|a, b| b[1] <=> a[1]}.first 10 # https://stackoverflow.com/questions/9615850/ruby-sort-array-of-an-array
    
    bar_chart top_10_data, id: "Top_10_solutions",  xtitle: "", ytitle: ""
  end
  
end
