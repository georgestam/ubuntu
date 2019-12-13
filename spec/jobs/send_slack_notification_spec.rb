describe SendNotificationsToSlack do

  let!(:user){ FactoryGirl.create :user }
  let(:slack_notifier)  { double(Slack::Web::Client) }
  let!(:alert){ FactoryGirl.create :alert }

  it "sends notification" do
    # TODO: test API and bacground job in rspec
    # 
    text = "New alert created by #{alert.created_by.name if alert.created_by.present?} for Customer #{alert.customer.first_name} #{alert.customer.last_name}: #{alert.type_alert.name}"
    expect(slack_notifier).to receive(:chat_postMessage).with(channel: '#alerts', text: text, as_user: 'ubuntu')
    SendNotificationsToSlack.perform_now(alert.id)
  end

end 