module StatsUsersHelper
  
  def alerts_by_user
    data = Alert.all.joins(:user).group("users.name").count
    column_chart data, id: "alerts-by-user", xtitle: "", ytitle: ""
  end
  
  def alerts_by_user_in_time  
    data = User.all.map { |user| 
      {name: user.name, data: user.find_alerts.group_by_day("alerts.created_at").count} }
    line_chart data, legend: "bottom", id: "alerts-by-user-in-time", xtitle: "", ytitle: ""
  end
  
  def resolved_alerts_by_user_in_time  
    data = User.all.map { |user| 
      {name: user.name, data: user.find_alerts.group_by_day("alerts.resolved_at").count} }
    line_chart data, legend: "bottom", id: "resolved-alerts-by-user-in-time", xtitle: "", ytitle: ""
  end
  
end