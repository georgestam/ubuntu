module StatsUsageHelper
  
  def yesterday_usage
    
  all_data = []
    
  Meter.all.each do |meter|
    data = []
    meter.usages_on(Date.yesterday).each do |usage_day|
      json = JSON.parse(usage_day.api_data)
      # hour:
      # json[0] > {"usage"=>9.675945420895e-05, "timestamp"=>"2017-09-25T00:00:00+00:00"}
      data = json.map do |usage_hour|
        [usage_hour["timestamp"], usage_hour["usage"]]
      end 
      
    end
    
    all_data << {name: "#{meter.customer.name}", data: data}
    
    end
    
    line_chart all_data, legend: "false", height: "600px", ytitle: "Kwh", xtitle: "24 hours"
  end 
  
end