module StatsHelper

  def alerts_by_type_alert
    data = Alert.all.joins(:type_alert).group("type_alerts.name").count # https://github.com/ankane/chartkick/issues/19
    bar_chart data, xtitle: "num. of alerts", ytitle: ""
  end
  
  def alerts_by_type_alert_dunut
    # data = Alert.all.group(:type_alert).count
    data = Alert.all.joins(:type_alert).group("type_alerts.name").count
    pie_chart data, donut: true, legend: "bottom"
  end
  
  def alerts_by_user
    data = Alert.all.joins(:user).group("users.name").count
    column_chart data, xtitle: "", ytitle: ""
  end
  
end
