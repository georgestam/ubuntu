module StatsTopupsHelper
  
  def average_topup_per_day
    
    all_data = []
    total_topup = [] 
    
    Customer.all.each do |customer|
      
      data = []
      average_customer_topup = 0
      
      (@start_date.to_date..@end_date.to_date).each do |date|
        cumulative = 0
        cumulative = cumulative_topup_calculation(date, customer, cumulative)
        
        average_hour = cumulative
        data << [date.to_s, average_hour]    
        average_customer_topup += average_hour 
   
      end
      
      all_data << {name: (customer.name).to_s, data: data, average_customer_topup: average_customer_topup }
      
    end      
    
    top_data = all_data.sort {|a, b| b[:average_customer_topup] <=> a[:average_customer_topup]}.first 10 # https://stackoverflow.com/questions/9615850/ruby-sort-array-of-an-array
    bottom_data = all_data.sort {|a, b| a[:average_customer_topup] <=> b[:average_customer_topup]}.first 40
    
    # calculate total average in the Community
    total_data = []
  
    (@start_date.to_date..@end_date.to_date).each do |date|
      cumulative = cumulative_topup_calculation_for_total_topup(date)
      
      average_topup = cumulative / Customer.count
      total_data << [date.to_s, average_hour]
      total_topup << [date.to_s, cumulative]
    end 
    
    top_data.unshift({name: "Community average", data: total_data })
    bottom_data.unshift({name: "Community average", data: total_data })
    
    @plot_total_topup = [
      {name: "Total topup", data: total_topup}
    ]
    @plot_top_custommer_with_topup = top_data
    @plot_bottom_custommer_with_topup = bottom_data
  end
  
  def total_topup_cumulative
    column_chart @plot_total_topup, id: "total-topup-cumulative", legend: "bottom", height: "600px", ytitle: "Kwh", xtitle: "days", library: basic_opts('Total community topup per day')
  end 
  
  def plot_top_custommer_with_topup
    line_chart @plot_top_custommer_with_topup, legend: "bottom", height: "600px", ytitle: "Kwh", xtitle: "days", library: basic_opts('Top 10 customers with more average topup per day')
  end 
  
  def plot_bottom_custommer_with_topup
    line_chart @plot_bottom_custommer_with_topup, legend: "bottom", height: "600px", ytitle: "Kwh", xtitle: "days", library: basic_opts('Bottom 40 customers with less average topup per day')
  end 
  
  def average_topup_per_week_during_24
    
    all_data = []
    
    # https://stackoverflow.com/questions/22695911/convert-date-range-to-array-of-weeks-and-months
    weeks = (@start_date.to_date..@end_date.to_date).select(&:sunday?).map(&:to_s) 
    
    Meter.all.each do |meter|
      
      data = []
      average_customer_topup = 0

      
      weeks.each do |week|  
        
        cumulative = 0
        
        (Date.parse(week)..(Date.parse(week) + 7.days)).each do |date|
          cumulative += cumulative_topup_calculation(date, meter, cumulative)
        end
        average_day = cumulative / 7
        data << [week, average_day]    
        average_customer_topup += average_day 
        
      end
      
      all_data << {name: (meter.customer.name).to_s, data: data, average_customer_topup: average_customer_topup }
      
    end 
    
    top_data = all_data.sort {|a, b| b[:average_customer_topup] <=> a[:average_customer_topup]}.first 10 # https://stackoverflow.com/questions/9615850/ruby-sort-array-of-an-array
    bottom_data = all_data.sort {|a, b| a[:average_customer_topup] <=> b[:average_customer_topup]}.first 40
    
    # calculate total average in the Community
    total_data = []
    
    weeks.each do |week| 
      cumulative = 0
      
      (Date.parse(week)..(Date.parse(week) + 7.days)).each do |date|
        cumulative += cumulative_topup_calculation_for_total_topup(date, cumulative)[0]  
      end 
    
      average_day = cumulative / (7 * Customer.count)
      total_data << [week, average_day]  
    end  
    
    top_data.unshift({name: "Community average", data: total_data })
    bottom_data.unshift({name: "Community average", data: total_data })
    
    @plot_top_custommer_with_topup_per_week = top_data
    @plot_bottom_custommer_with_topup_per_week = bottom_data
    
  end
  
  def plot_top_custommer_with_topup_per_week
    line_chart @plot_top_custommer_with_topup_per_week, legend: "bottom", height: "600px", ytitle: "Kwh", xtitle: "weeks", library: basic_opts('Top 10 customers with more average topup per day (24h)')
  end 
  
  def plot_bottom_custommer_with_topup_per_week
    line_chart @plot_bottom_custommer_with_topup_per_week, legend: "bottom", height: "600px", ytitle: "Kwh", xtitle: "weeks", library: basic_opts('Bottom 40 customers with less average topup per day (24h)')
  end 
  
  def cumulative_topup_calculation(date, customer, cumulative = 0) 
    dates = date.beginning_of_day..date.end_of_day # we should only pass one full day
    topups = Topup.where(customer: customer, created_on: date)
    
    topups.map do |topup|
      cumulative += topup.amount
    end 
    cumulative
  end 
  
  def cumulative_topup_calculation_for_total_topup(date, cumulative = 0) 
    
    cumulative_morning = 0
    cumulative_evening = 0
    
    topups = Topup.where(created_on: date)
    
    topups.each do |topup|
      cumulative += topup_hour["topup"].to_f
    end
    cumulative
  end 
  
end