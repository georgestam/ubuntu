module StatsUsageHelper
  
  def average_usage_per_day_during_24
    
    all_data = []
    
    Meter.all.each do |meter|
      
      data = []
      average_customer_usage = 0
      
      (@start_date.to_date..@end_date.to_date).each do |date|
        cumulative = 0
        cumulative = cumulative_calculation(date, meter, cumulative)
        
        average_hour = cumulative / 24
        data << [date.to_s, average_hour]    
        average_customer_usage += average_hour 
   
      end
      
      all_data << {name: (meter.customer.name).to_s, data: data, average_customer_usage: average_customer_usage }
      
    end      
    
    top_data = all_data.sort {|a, b| b[:average_customer_usage] <=> a[:average_customer_usage]}.first 10 # https://stackoverflow.com/questions/9615850/ruby-sort-array-of-an-array
    bottom_data = all_data.sort {|a, b| a[:average_customer_usage] <=> b[:average_customer_usage]}.first 40
    
    # calculate total average in the Community
    total_data = []
  
    (@start_date.to_date..@end_date.to_date).each do |date|
      cumulative = cumulative_calculation_for_total_usage(date)
      
      average_hour = cumulative / (24 * Customer.count)
      total_data << [date.to_s, average_hour]    
    end 
    
    top_data.unshift({name: "Community average", data: total_data })
    bottom_data.unshift({name: "Community average", data: total_data })
    
    @plot_top_custommer_with_usage = top_data
    @plot_bottom_custommer_with_usage = bottom_data
  end
  
  def plot_top_custommer_with_usage
    line_chart @plot_top_custommer_with_usage, legend: "bottom", height: "600px", ytitle: "Kwh", xtitle: "days", library: basic_opts('Top 10 customers with more average usage per hour (24h)')
  end 
  
  def plot_bottom_custommer_with_usage
    line_chart @plot_bottom_custommer_with_usage, legend: "bottom", height: "600px", ytitle: "Kwh", xtitle: "days", library: basic_opts('Bottom 40 customers with less average usage per hour (24h)')
  end 
  
  def average_usage_per_week_during_24
    
    all_data = []
    
    # https://stackoverflow.com/questions/22695911/convert-date-range-to-array-of-weeks-and-months
    weeks = (@start_date.to_date..@end_date.to_date).select(&:sunday?).map(&:to_s) 
    
    Meter.all.each do |meter|
      
      data = []
      average_customer_usage = 0

      
      weeks.each do |week|  
        
        cumulative = 0
        
        (Date.parse(week)..(Date.parse(week) + 7.days)).each do |date|
          cumulative += cumulative_calculation(date, meter, cumulative)
        end
        average_day = cumulative / 7
        data << [week, average_day]    
        average_customer_usage += average_day 
        
      end
      
      all_data << {name: (meter.customer.name).to_s, data: data, average_customer_usage: average_customer_usage }
      
    end 
    
    top_data = all_data.sort {|a, b| b[:average_customer_usage] <=> a[:average_customer_usage]}.first 10 # https://stackoverflow.com/questions/9615850/ruby-sort-array-of-an-array
    bottom_data = all_data.sort {|a, b| a[:average_customer_usage] <=> b[:average_customer_usage]}.first 40
    
    # calculate total average in the Community
    total_data = []
    
    weeks.each do |week| 
      cumulative = 0
      
      (Date.parse(week)..(Date.parse(week) + 7.days)).each do |date|
        cumulative += cumulative_calculation_for_total_usage(date, cumulative)  
      end 
    
      average_day = cumulative / (7 * Customer.count)
      total_data << [week, average_day]  
    end  
    
    top_data.unshift({name: "Community average", data: total_data })
    bottom_data.unshift({name: "Community average", data: total_data })
    
    @plot_top_custommer_with_usage_per_week = top_data
    @plot_bottom_custommer_with_usagep_per_week = bottom_data
    
  end
  
  def plot_top_custommer_with_usage_per_week
    line_chart @plot_top_custommer_with_usage_per_week, legend: "bottom", height: "600px", ytitle: "Kwh", xtitle: "weeks", library: basic_opts('Top 10 customers with more average usage per day (24h)')
  end 
  
  def plot_bottom_custommer_with_usagep_per_week
    line_chart @plot_bottom_custommer_with_usagep_per_week, legend: "bottom", height: "600px", ytitle: "Kwh", xtitle: "weeks", library: basic_opts('Bottom 40 customers with less average usage per day (24h)')
  end
  
  def yesterday_usage_hourly
    
    all_data = []

    Meter.all.each do |meter|
      dates = @start_date.beginning_of_day..@end_date.end_of_day
      json = Usage.generate_usage_json(meter, dates)
      # hour:
      # json[0] > {"usage"=>9.675945420895e-05, "timestamp"=>"2017-09-25T00:00:00+00:00"
      
      data = json.map do |usage_hour|
        [usage_hour["timestamp"], usage_hour["usage"]]
      end 
      
      all_data << {name: (meter.customer.name).to_s, data: data}
      
    end 
        
    line_chart all_data, legend: "false", height: "600px", ytitle: "Kwh", xtitle: "24 hours"
  
  end 
  
  def yesterday_usage_cumulative
    
    all_data = []
      
    constant_maximum_usage = []
    time = DateTime.new(DateTime.yesterday.year, DateTime.yesterday.month, DateTime.yesterday.day).in_time_zone

    24.times do 
      constant_maximum_usage << [time, Usage.max_usage_per_customer] 
      time += 1.hour # https://stackoverflow.com/questions/238684/subtract-n-hours-from-a-datetime-in-ruby
    end 
    
    all_data << { name: "max usage per customer", data: constant_maximum_usage }
  
    Meter.all.each do |meter|
      json = Usage.generate_usage_json(meter)
      # hour:
      # json[0] > {"usage"=>9.675945420895e-05, "timestamp"=>"2017-09-25T00:00:00+00:00"}
      cumulative = 0
      data = json.map do |usage_hour|
        cumulative += usage_hour["usage"].to_f
        [usage_hour["timestamp"], cumulative]
      end 
      
      all_data << {name: (meter.customer.name).to_s, data: data}
      
    end 
    
    line_chart all_data, legend: "false", height: "600px", ytitle: "Kwh", xtitle: "24 hours"
  
  end  
  
  def monthly_usage(full_month)
    
    all_data = []

    Meter.all.each do |meter|
      data = []
      meter.usages_this_month(full_month.month).each do |usage_day|
        json = test? ? JSON.parse(File.read(usage_day.api_data)) : JSON.parse(usage_day.api_data)
        # hour:
        # json[0] > {"usage"=>9.675945420895e-05, "timestamp"=>"2017-09-25T00:00:00+00:00"}
        json.each do |usage_hour|
          data << [usage_hour["timestamp"], usage_hour["usage"]]
        end 
        
      end
    
      all_data << {name: (meter.customer.name).to_s, data: data}
    
    end
    
    line_chart all_data, legend: "false", height: "600px", ytitle: "Kwh", xtitle: "hours"
  end    
  
  def cumulative_calculation(date, meter, cumulative = 0) 
    dates = date.beginning_of_day..date.end_of_day # we should only pass one full day
    json = Usage.generate_usage_json(meter, dates)
    
    json.map do |usage_hour|
      cumulative += usage_hour["usage"].to_f
    end 
    cumulative
  end 
  
  def cumulative_calculation_for_total_usage(date, cumulative = 0) 
    
    raw_data_usages = Usage.where(created_on: date)
    
    raw_data_usages.each do |raw_data|
      json = if raw_data
        test? ? JSON.parse(File.read(raw_data.api_data)) : JSON.parse(raw_data.api_data)
      else 
        []
      end
      
      json.each do |usage_hour|
        cumulative += usage_hour["usage"].to_f
      end 
    end
    cumulative
  end 
  
end