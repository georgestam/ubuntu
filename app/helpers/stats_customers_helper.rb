module StatsCustomersHelper
  def top_10_customers_with_more_alerts
    data = Alert.joins(:customer).group("customers.id").count.map{|costumer_id, count| [costumer_id ? Customer.find(costumer_id).name : "Unassigned", count] } # https://github.com/ankane/chartkick/issues/19
    top_10_data = data.sort {|a,b| b[1] <=> a[1]}.first 10 # https://stackoverflow.com/questions/9615850/ruby-sort-array-of-an-array
    bar_chart top_10_data, id: "top-10-customers-with-more-alerts",  xtitle: "", ytitle: "", library: {
      scales: {
          xAxes: [{
              ticks: {
                  fixedStepSize: 1 # remove decimals
              }
          }],
      },
    }
  end
  
  def top_10_customers_with_less_alerts
    data = Alert.joins(:customer).group("customers.id").count.map{|costumer_id, count| [costumer_id ? Customer.find(costumer_id).name : "Unassigned", count] } # https://github.com/ankane/chartkick/issues/19
    top_10_data = data.sort {|a,b| a[1] <=> b[1]}.first 10 # https://stackoverflow.com/questions/9615850/ruby-sort-array-of-an-array
    bar_chart top_10_data, id: "top-10-customers-with-less-alerts",  xtitle: "", ytitle: "", library: {
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


