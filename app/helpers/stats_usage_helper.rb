module StatsUsageHelper
  
  def average_usage_all_day_in_hours(order = "asc")
    
    all_data = []
    
    Meter.all.each do |meter|
      
      data = []
      total_usage = 0
      
      (@start_date.to_date..@end_date.to_date).each do |date|
        dates = date.beginning_of_day..date.end_of_day
        json = Usage.generate_usage_json(meter, dates)
        
        cumulative = 0
        json.map do |usage_hour|
          cumulative += usage_hour["usage"].to_f
        end 
        
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
    
    binding.pry
    
    line_chart top_10_data, legend: "bottom", height: "600px", ytitle: "Kwh", xtitle: "days", library: basic_opts('Top 10 customers with more average usage in a full day (all day)')
  
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
  
end