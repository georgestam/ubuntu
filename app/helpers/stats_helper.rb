module StatsHelper

  def alerts_by_type_alert
    # data = Alert.all.joins(:user).group("users.email").count
    data = Alert.all.joins(:type_alert).group("type_alerts.name").count # https://github.com/ankane/chartkick/issues/19
    bar_chart data, height: '300px', library: {
      title: {text: 'Alerts by type of alert', x: -20},
      yAxis: {  
        allowDecimals: false,
        title: {
          text: 'Type of alert'
         }
      },
      xAxis: {
         title: {
             text: 'Alerts'
         }
      }
    }
  end
  
  def alerts_by_type_alert_dunut
    # data = Alert.all.group(:type_alert).count
    data = Alert.all.joins(:type_alert).group("type_alerts.name").count
    pie_chart data, donut: true, legend: "bottom", height: '300px', library: {
      title: {text: 'Alerts by type of alert', x: -20},
      yAxis: {
         allowDecimals: false,
         title: {
             text: 'Type of alert'
         }
      },
      xAxis: {
         title: {
             text: 'Alerts'
         }
      }
    }
  end
  
end
