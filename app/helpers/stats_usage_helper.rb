module StatsUsageHelper
  
  def yesterday_usage_hourly
    
    all_data = []

    Meter.all.each do |meter|
      data = []
      json = if raw_data = meter.usages.where(created_on: Date.yesterday).first.try(:api_data)
        test? ? JSON.parse(File.read(raw_data)) : JSON.parse(raw_data)
      else 
        []
      end 
      # hour:
      # json[0] > {"usage"=>9.675945420895e-05, "timestamp"=>"2017-09-25T00:00:00+00:00"}
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
    time = DateTime.new(DateTime.yesterday.year, DateTime.yesterday.month, DateTime.yesterday.day)

    24.times do 
      constant_maximum_usage << [time, Usage.max_usage_per_customer] 
      time += (1 / 24.0) # https://stackoverflow.com/questions/238684/subtract-n-hours-from-a-datetime-in-ruby
    end 
    
    all_data << { name: "max usage per customer", data: constant_maximum_usage }
  
    Meter.all.each do |meter|
      data = []
      json = if raw_data = meter.usages.where(created_on: Date.yesterday).first.try(:api_data)
        test? ? JSON.parse(File.read(raw_data)) : JSON.parse(raw_data)
      else 
        []
      end 
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