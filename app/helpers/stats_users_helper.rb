module StatsUsersHelper
  
  def alerts_by_user
    data = Alert.all.joins(:user).group("users.name").count
    column_chart data, id: "alerts-by-user", xtitle: "", ytitle: ""
  end
  
  def alerts_by_user_in_time
    series_a = Alert.all.joins(:user).group("users.name").count
    # column_chart data, 
    
    column_chart [
      {name: "Created Alerts", data: series_a},
      {name: "Resolved Alerts", data: series_a}
    ], id: "alerts-by-user-in-time", legend: "bottom", xtitle: "", ytitle: ""
    
    # data = GroupAlert.all.map { |group_alert| 
    #   {name: group_alert.title, data: GroupAlert.joins(:alerts).group_by_day("alerts.created_at").count} }
    # line_chart data, legend: "bottom"
  end
  
end