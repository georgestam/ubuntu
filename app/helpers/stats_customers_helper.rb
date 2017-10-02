module StatsCustomersHelper
  def top_10_customers(order)
    data = select_range_of_dates_for(Alert.all).joins(:customer).group("customers.id").count.map{|costumer_id, count| [costumer_id ? Customer.find(costumer_id).name : "Unassigned", count] } # https://github.com/ankane/chartkick/issues/19
    top_10_data = if order == "asc"
      data.sort {|a, b| b[1] <=> a[1]}.first 10 # https://stackoverflow.com/questions/9615850/ruby-sort-array-of-an-array
      else
      data.sort {|a, b| a[1] <=> b[1]}.first 10
    end 
    bar_chart top_10_data, id: order == "asc" ? "top-10-customers-with-more-alerts" : "top-10-customers-with-less-alerts",  xtitle: "", ytitle: "", library: basic_opts('Top 10 customers with more Alerts')
  end
  
end