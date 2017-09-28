module StatsCustomersHelper
  def top_10_customers_with_more_alerts
    data = Alert.joins(:customer).group("customers.id").count.map{|costumer_id, count| [costumer_id ? Customer.find(costumer_id).name : "Unassigned", count] } # https://github.com/ankane/chartkick/issues/19
    bar_chart data, id: "top-10-customers-with-more-alerts",  xtitle: "", ytitle: "", library: {
      scales: {
          xAxes: [{
              ticks: {
                  fixedStepSize: 1 # remove decimals
              }
          }],
      },
    }
  end 
end
