module ApplicationHelper
  
 def truncate_string(string)
   truncate(string, :length => 40)
 end 
 
 private
 
# stats methods

  def basic_opts(title)
    {
      library: {
        title: {
             display: true,
             fontSize: 15,
             text: "#{title} - #{@start_date.strftime('%d %b %Y') } to #{@end_date.strftime('%d %b %Y') }"
         }
      }
    }
  end
  
  def by_day(records)
    opts = ['created_at', {range: @start_date..@end_date, format: '%d %b'}]
    method_name = :group_by_day
    if by_year?
      opts[1].merge!({format: '%Y'})
      method_name = :group_by_year
    elsif by_month?
      opts[1].merge!({format: '%b %Y'})
      method_name = :group_by_month
    end
    # alerts = @alerts.group_by_day('created_at', format: '%d %b', range: @start_date..@end_date).count
    alerts = records.send(method_name, *opts).count
    data = [{name: 'alerts test', data: alerts}]
  end
  
  def by_year?
    @end_date - (1.year + 2.days) > @start_date
  end

  def by_month?
    @end_date - (3.month + 2.days) > @start_date
  end

end 