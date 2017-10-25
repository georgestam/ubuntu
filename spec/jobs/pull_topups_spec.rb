describe UpdateToupsJob do
  
  it "calls the create_topup_from_api method once the job is called" do
    FactoryGirl.create_list(:customer, 1)
    expect(Topup).to receive(:create_topup_from_api).at_least(1).times.and_call_original
    UpdateToupsJob.perform_now 
  end
  
end 