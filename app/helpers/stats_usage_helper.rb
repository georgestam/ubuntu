module StatsUsageHelper
  
  def average_usage_per_day_during_24(order = "asc")
    
    all_data = []
    
    Meter.all.each do |meter|
      
      data = []
      total_usage = 0
      
      (@start_date.to_date..@end_date.to_date).each do |date|
        cumulative = 0
        cumulative = cumulative_calculation(date, meter, cumulative)
        
        data << [date.to_s, cumulative]    
        total_usage += cumulative
        
      end
      
      all_data << {name: (meter.customer.name).to_s, data: data, total_usage: total_usage }
      
    end 
    
    top_10_data = if order == "asc"
      all_data.sort {|a, b| b[:total_usage] <=> a[:total_usage]}.first 10 # https://stackoverflow.com/questions/9615850/ruby-sort-array-of-an-array
      else
      all_data.sort {|a, b| a[:total_usage] <=> b[:total_usage]}.first 10
    end 
    
    line_chart top_10_data, legend: "bottom", height: "600px", ytitle: "Kwh", xtitle: "days", library: basic_opts('Top 10 customers with more average usage per day (24h)')
  
  end
  
  def average_usage_per_week_during_24(order = "asc")
    
    all_data = []
    
    Meter.all.each do |meter|
      
      data = []
      total_usage = 0

      # https://stackoverflow.com/questions/22695911/convert-date-range-to-array-of-weeks-and-months
      weeks = (@start_date.to_date..@end_date.to_date).select(&:sunday?).map(&:to_s) 
      
      cumulative = 0
      
      weeks.each do |week|  
        
        (DateTime.parse(week).in_time_zone..(DateTime.parse(week).in_time_zone + 7.days)).each do |date|
          cumulative = cumulative_calculation(date, meter, cumulative)
        end
        
        data << [week, cumulative]    
        total_usage += cumulative
        
      end
      
      all_data << {name: (meter.customer.name).to_s, data: data, total_usage: total_usage }
      
    end 
    
    top_10_data = if order == "asc"
      all_data.sort {|a, b| b[:total_usage] <=> a[:total_usage]}.first 10 # https://stackoverflow.com/questions/9615850/ruby-sort-array-of-an-array
      else
      all_data.sort {|a, b| a[:total_usage] <=> b[:total_usage]}.first 10
    end 
    
    line_chart top_10_data, legend: "bottom", height: "600px", ytitle: "Kwh", xtitle: "weeks", library: basic_opts('Top 10 customers with more average usage per week (24h)')
  
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
    dates = date.beginning_of_day..date.end_of_day
    json = Usage.generate_usage_json(meter, dates)
    
    json.map do |usage_hour|
      cumulative += usage_hour["usage"].to_f
    end 
    cumulative
  end 
  
end