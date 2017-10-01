describe PullUsageJob do
  
  it "calls the request_usage_to_api method once the job is called" do
    FactoryGirl.create_list(:customer, 3)
    expect(Usage).to receive(:request_usage_to_api).at_least(Customer.count).times.and_call_original
    PullUsageJob.perform_now 
  end
  
end 