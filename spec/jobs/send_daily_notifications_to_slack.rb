describe SendDailyRemindersToSlackJob do
  
  let!(:user){ FactoryGirl.create :user, slack_username: "@jordi" }
  
  it "calls notify_open_alerts_to_slack method when the job is called" do
    expect(Alert).to receive(:notify_open_alerts_to_slack).at_least(1).times.and_call_original
    SendDailyRemindersToSlackJob.perform_now
  end
  
end 