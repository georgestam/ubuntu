module StatsAlertsHelper

  def alerts_by_type_alert
    data = Alert.all.joins(:type_alert).group("type_alerts.name").count # https://github.com/ankane/chartkick/issues/19
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
    {name: group_alert.title, data: group_alert.alerts.group_by_day("alerts.created_at").count} }
  line_chart data, legend: "bottom"
  end 
  
  def total_alerts_in_time
    
    alerts_created = Alert.all.group_by_week(:created_at).count
    alerts_resolved = Alert.all.group_by_week(:resolved_at).count
    
    data =  [
      {name: "Created Alerts", data: alerts_created},
      {name: "Resolved Alerts", data: alerts_resolved}
    ]
    
    column_chart data, id: "total-alerts-in-time", legend: "bottom", xtitle: "", ytitle: ""
    
  end
  
end
