describe PullUsageJob do
  
  it "calls the request_usage_to_api method once the job is called" do
    expect(Usage).to receive(:request_usage_to_api).at_least(1).times.and_call_original
    PullUsageJob.perform_now 
  end
  
end 