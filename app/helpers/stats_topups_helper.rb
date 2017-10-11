module StatsTopupsHelper
  
  def top_10_customers_with_topups(order)
    data = Topup.where(:created_on => @start_date.beginning_of_day..@end_date.end_of_day).joins(:customer).group("customers.id").count.map{|costumer_id, count| [costumer_id ? Customer.find(costumer_id).name : "Unassigned", count] } # https://github.com/ankane/chartkick/issues/19
    top_10_data = if order == "asc"
      data.sort {|a, b| b[1] <=> a[1]}.first 10 # https://stackoverflow.com/questions/9615850/ruby-sort-array-of-an-array
      else
      data.sort {|a, b| a[1] <=> b[1]}.first 40
    end 
    bar_chart top_10_data, id: order == "asc" ? "top-10-customers-with-more-topups" : "Bottom-40-customers-with-less-topups",  xtitle: "", ytitle: "", library: basic_opts_without_decimals(order == "asc" ? "Top 10 customers with more topups (count)" : "Bottom 40 customers with less topups  (count)")
  end 
  
  def top_10_customers_with_topups_in_time
    
    data = Customer.includes(:topups).map { |customer|
      topups = Topup.where(customer: customer)
      sub_data = by_week(topups, "created_on")
      {name: customer.name, data: sub_data, cumulative: topups.count } 
    }
    
    top_data = data.sort {|a, b| b[:cumulative] <=> a[:cumulative]}.first 10
    
    line_chart top_data, legend: "bottom", xtitle: "", ytitle: "", library: basic_opts('Top 10 customers with more topups per week (count)')
  end 
  
  def top_10_customers_with_topups_sum(order)
    data = Topup.where(:created_on => @start_date.beginning_of_day..@end_date.end_of_day).joins(:customer).group("customers.id").sum(:amount).map{|costumer_id, count| [costumer_id ? Customer.find(costumer_id).name : "Unassigned", count] } # https://github.com/ankane/chartkick/issues/19
    top_10_data = if order == "asc"
      data.sort {|a, b| b[1] <=> a[1]}.first 10 # https://stackoverflow.com/questions/9615850/ruby-sort-array-of-an-array
      else
      data.sort {|a, b| a[1] <=> b[1]}.first 40
    end 
    bar_chart top_10_data, id: order == "asc" ? "top-10-customers-with-more-topups-sum" : "Bottom-40-customers-with-less-topups",  xtitle: "KES", ytitle: "", library: basic_opts(order == "asc" ? "Top 10 customers with more topups (sum)" : "'Bottom 40 customers with less topups (sum)'")
  end 
  
  def top_10_customers_with_topups_in_time_sum
    
    data = Customer.includes(:topups).map { |customer|
      topups = Topup.where(customer: customer)
      sub_data = by_week(topups, "created_on", "sum")
      {name: customer.name, data: sub_data, cumulative: topups.sum(:amount) } 
    }
    
    top_data = data.sort {|a, b| b[:cumulative] <=> a[:cumulative]}.first 10
    
    line_chart top_data, legend: "bottom", xtitle: "", ytitle: "KES", library: basic_opts('Top 10 customers with more topups per week (sum)')
  end
  
end