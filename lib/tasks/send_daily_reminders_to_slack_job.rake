namespace :send_daily_reminders_to_slack_job do
  desc "Send daily notifications of open alerts to slack"
  task send_all: :environment do
    SendDailyRemindersToSlackJob.perform_later
  end
end
