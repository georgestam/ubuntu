describe UpdateDbJob do
  
  before {
    negative_acount = FactoryGirl.create :type_alert, name: "Negative account"
  }
  
  it "calls the update_customer_db method once the job is called" do
    expect(Customer).to receive(:update_customer_db).at_least(1).times.and_call_original
    UpdateDbJob.perform_now 
  end
  
  it "calls the check_customers_with_negative_acount method once the job is called" do
    expect(Alert).to receive(:check_customers_with_negative_acount).at_least(1).times.and_call_original
    UpdateDbJob.perform_now 
  end
  
end 