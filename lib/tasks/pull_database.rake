namespace :pull_database do
  desc "Pull Database from Steama and run alerts (async)"
  task update_all: :environment do
    UpdateDbJob.perform_later
  end
  
  desc "Pull usage from Steama (async)"
  task pull_usage_from_yesterday: :environment do
    PullUsageJob.perform_later
    GenerateUsageAlertsJob.perform_later
  end

end
