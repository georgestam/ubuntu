module StatsTopupsHelper
  
  def top_10_customers_with_topups(order)
    data = Topup.where(:created_on => @start_date.beginning_of_day..@end_date.end_of_day).joins(:customer).group("customers.id").count.map{|costumer_id, count| [costumer_id ? Customer.find(costumer_id).name : "Unassigned", count] } # https://github.com/ankane/chartkick/issues/19
    top_10_data = sort_records(order, data) 
    bar_chart top_10_data, id: order == "asc" ? "top-10-customers-with-more-topups" : "Bottom-40-customers-with-less-topups",  xtitle: "", ytitle: "", library: basic_opts_without_decimals(order == "asc" ? "Top 10 customers with more topups (count)" : "Bottom 40 customers with less topups  (count)")
  end 
  
  def top_10_customers_with_topups_in_time
    
    data = Customer.all.map { |customer|
      topups = Topup.where(customer: customer)
      sub_data = by_week(topups, "created_on")
      {name: customer.name, data: sub_data, cumulative: topups.count } 
    }
    
    top_data = data.sort {|a, b| b[:cumulative] <=> a[:cumulative]}.first 10
    
    community_total = by_week(Topup.all, "created_on", "count")
    # calculate the average
    community_total.each { |k, v| community_total[k] = (v.to_f / Customer.all.count) } 
    
    top_data.unshift({name: "Commnutiy average", data: community_total}) 
    
    line_chart top_data, legend: "bottom", xtitle: "", ytitle: "", library: basic_opts('Top 10 customers with more topups per week (count)')
  end 
  
  def top_10_customers_with_topups_sum(order)
    data = Topup.where(:created_on => @start_date.beginning_of_day..@end_date.end_of_day).joins(:customer).group("customers.id").sum(:amount).map{|costumer_id, count| [costumer_id ? Customer.find(costumer_id).name : "Unassigned", count] } # https://github.com/ankane/chartkick/issues/19
    top_10_data = sort_records(order, data)
    bar_chart top_10_data, id: order == "asc" ? "top-10-customers-with-more-topups-sum" : "Bottom-40-customers-with-less-topups",  xtitle: "KES", ytitle: "", library: basic_opts(order == "asc" ? "Top 10 customers with more topups (sum)" : "'Bottom 40 customers with less topups (sum)'")
  end 
  
  def top_10_customers_with_topups_in_time_sum
    
    data = Customer.all.map { |customer|
      topups = Topup.where(customer: customer)
      sub_data = by_week(topups, "created_on", "sum")
      {name: customer.name, data: sub_data, cumulative: topups.sum(:amount) } 
    }
      
    top_data = data.sort {|a, b| b[:cumulative] <=> a[:cumulative]}.first 10
    
    community_total = by_week(Topup.all, "created_on", "sum")
    # calculate the average
    community_total.each { |k, v| community_total[k] = (v.to_f / Customer.all.count) } 
    
    top_data.unshift({name: "Commnutiy average", data: community_total})  
    
    line_chart top_data, legend: "bottom", xtitle: "", ytitle: "KES", library: basic_opts('Top 10 customers with more topups per week (sum)')
  end
  
  def customer_indivicual_graph_topups_in_time
    data = [@customer].map { |customer|
      topups = Topup.where(customer: customer)
      sub_data = by_week(topups, "created_on")
      {name: customer.name, data: sub_data, cumulative: topups.count } 
    }
    
    line_chart data, legend: "bottom", xtitle: "", ytitle: "", library: basic_opts("#{@customer.first_name} topups per week (count)")
    
  end 
  
  def customer_indivicual_graph_in_time_sum
    data = [@customer].map { |customer|
      topups = Topup.where(customer: customer)
      sub_data = by_week(topups, "created_on", "sum")
      {name: customer.name, data: sub_data, cumulative: topups.sum(:amount) } 
    }
    
    line_chart data, legend: "bottom", xtitle: "", ytitle: "KES", library: basic_opts("#{@customer.first_name} topups per week (sum)")
  
  end  
  
  def sort_customers_with_topups_in_time_sum
    data = Customer.where(ignore_alerts: false).map { |customer|
      topups = Topup.where(customer: customer)
      sub_data = by_week(topups, "created_on", "sum")
      {id: customer.id, data: sub_data, cumulative: topups.sum(:amount) } 
    }
      
    @data_sorted = data.sort {|a, b| b[:cumulative] <=> a[:cumulative]}

  end
  
end