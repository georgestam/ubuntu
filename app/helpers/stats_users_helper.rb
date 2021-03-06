module StatsUsersHelper
  
  def assigned_alerts
    data = select_range_of_dates_for(Alert.all_not_hidden).joins(:user).group("users.name").count
    pie_chart data, donut: true, legend: "bottom", library: basic_opts('% Assigned alerts')
  end
  
  def alerts_by_user
    alerts_assigned = select_range_of_dates_for(Alert.all_not_hidden).joins(:user).group("users.name").count
    alerts_resolved = select_range_of_dates_for(Alert.all_not_hidden.all_resolved).joins(:user).group("users.name").count
    alerts_open = select_range_of_dates_for(Alert.all_not_hidden.all_open).joins(:user).group("users.name").count
    
    data = [
      {name: "Assigned Alerts", data: alerts_assigned},
      {name: "Resolved Alerts", data: alerts_resolved},
      {name: "Open Alerts", data: alerts_open}
    ]
    
    column_chart data, id: "total-alerts-by_user", legend: "bottom", xtitle: "", ytitle: "", library: basic_opts('Total Alerts')
    
  end
  
  def alerts_by_user_in_time(attribute)  
    data = User.all.map do |user| 
      if user.find_alerts.all_not_hidden.any?
        {name: user.name, data: by_week(user.find_alerts.all_not_hidden, attribute)}
      end 
    end  
    # Compact remove nil elements from the hash data
    column_chart data.compact, legend: "bottom", xtitle: "", ytitle: "", id: attribute == "alerts.created_at" ? "alerts-by-user-in-time" : "resolved-alerts-by-user-in-time", 
                               library: basic_opts("#{attribute == "alerts.created_at" ? "Created" : "Resolved"} alerts")
  end
  
  def alerts_created_by_user  
    data = User.all.map do |user| 
      if user.find_created_by_alerts.all_not_hidden.any?
        {name: user.name, data: by_week(user.find_created_by_alerts.all_not_hidden, "alerts.created_at")} 
      end 
    end 
    # Compact remove nil elements from the hash data
    column_chart data.compact, legend: "bottom", xtitle: "", ytitle: "", library: basic_opts('Alerts created by user')
  end
  
end