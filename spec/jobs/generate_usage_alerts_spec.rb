describe GenerateUsageAlertsJob do
  
  it "calls the check_meters_exceeding_max_daily_usage method once the job is called" do
    expect(Alert).to receive(:check_meters_exceeding_max_daily_usage).at_least(1).times.and_call_original
    GenerateUsageAlertsJob.perform_now 
  end
  
end 