module ApplicationHelper
  
 def truncate_string(string)
   truncate(string, :length => 40)
 end 
 
 private
 
# stats methods

  def basic_opts(title)
    {
      title: {
           display: true,
           fontSize: 12,
           padding: 50,
           text: "#{title} - #{@start_date.strftime('%d %b %Y') } to #{@end_date.strftime('%d %b %Y') }"
       }
    }
  end
  
  def basic_opts_without_decimals(title)
    {
      scales: {
          xAxes: [{
              ticks: {
                  fixedStepSize: 0.25 # remove decimals
              }
          }]
      },
      title: {
           display: true,
           fontSize: 12,
           padding: 50,
           text: "#{title} - #{@start_date.strftime('%d %b %Y') } to #{@end_date.strftime('%d %b %Y') }"
       }
    }
  end
  
  def by_week(records, group_by, group_type = "count")
    opts = [group_by, {range: @start_date..@end_date, format: '%d %b'}]
    method_name = :group_by_week
    if by_year?
      opts[1].merge!({format: '%Y'})
      method_name = :group_by_year
    elsif by_month?
      opts[1].merge!({format: '%b %Y'})
      method_name = :group_by_month
    end
    # alerts = @alerts.group_by_day('created_at', format: '%d %b', range: @start_date..@end_date).count
    alerts = if group_type == "count"
      records.send(method_name, *opts).count
    else
      records.send(method_name, *opts).sum(:amount)
    end 
  end
  
  def by_year?
    @end_date - (1.year + 2.days) > @start_date
  end

  def by_month?
    @end_date - (3.month + 2.days) > @start_date
  end
  
  def select_range_of_dates_for(records)
    records.where(:created_at => @start_date.beginning_of_day..@end_date.end_of_day)
  end 
  
  def sort_records(order, data, number_of_bottom_records = 40)
    data = if order == "asc"
      data.sort {|a, b| b[1] <=> a[1]}.first 10 # https://stackoverflow.com/questions/9615850/ruby-sort-array-of-an-array
      else
      data.sort {|a, b| a[1] <=> b[1]}.first 40
    end 
  end 

end 