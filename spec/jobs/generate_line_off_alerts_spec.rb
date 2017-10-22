describe CreateAlertsForLineOffJob do
  
  let(:line_off_type_alert) { FactoryGirl.create :type_alert, name: "Line is off" }
  
  it "calls the create_alert_for_customers_with_line_off method once the job is called" do
    FactoryGirl.create :issue, type_alert: line_off_type_alert
    expect(Alert).to receive(:create_alert_for_customers_with_line_off).at_least(1).times.and_call_original
    CreateAlertsForLineOffJob.perform_now 
  end
  
end 