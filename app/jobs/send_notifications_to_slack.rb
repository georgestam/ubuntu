class SendNotificationsToSlack < ApplicationJob
  queue_as :default

  def perform
    puts "I'm starting jobs"
    client = Slack::Web::Client.new
    client.auth_test
    client.chat_postMessage(channel: '#alerts', text: 'Hello World', as_user: 'ubuntu')
    puts "OK I'm done now"
  end
end
