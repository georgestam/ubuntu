module StatsUsersHelper
  
  def alerts_by_user
    alerts_assigned = Alert.all.joins(:user).group("users.name").count
    alerts_resolved = Alert.all_resolved.joins(:user).group("users.name").count
    alerts_open = Alert.all_open.joins(:user).group("users.name").count
    
    data = [
      {name: "Assigned Alerts", data: alerts_assigned},
      {name: "Resolved Alerts", data: alerts_resolved},
      {name: "Open Alerts", data: alerts_open}
    ]
    
    column_chart data, id: "total-alerts-by_user", legend: "bottom", xtitle: "", ytitle: ""
    
  end
  
  def alerts_by_user_in_time(attribute)  
    data = User.all.map do |user| 
      if user.find_alerts.any?
        {name: user.name, data: user.find_alerts.group_by_day(attribute).count}
      end 
    end  
    # Compact remove nil elements from the hash data
    line_chart data.compact, legend: "bottom", id: attribute == "alerts.created_at" ? "alerts-by-user-in-time" : "resolved-alerts-by-user-in-time", xtitle: "", ytitle: ""
  end
  
  def alerts_created_by_user  
    data = User.all.map do |user| 
      if user.find_created_by_alerts.any?
        {name: user.name, data: user.find_created_by_alerts.group_by_day("alerts.created_at").count} 
      end 
    end 
    # Compact remove nil elements from the hash data
    line_chart data.compact, legend: "bottom", xtitle: "", ytitle: ""
  end
  
end