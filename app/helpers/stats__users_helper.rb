module StatsUsersHelper
  
  def alerts_by_user
    data = Alert.all.joins(:user).group("users.name").count
    column_chart data, xtitle: "", ytitle: ""
  end
  
end
