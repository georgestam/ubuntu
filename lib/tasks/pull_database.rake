namespace :pull_database do
  desc "Pull Database from Steama and run alerts (async)"
  task update_all: :environment do
    UpdateDbJob.perform_later
  end
  
  desc "Pull usage from Steama (async)"
  task pull_usage_from_yesterday: :environment do
    PullUsageJob.perform_later
  end
  
  desc "Gereate alerts due to usage from yesterday (async)"
  task genarate_usage_alerts_from_yesterday: :environment do
    GenerateUsageAlertsJob.perform_later
  end
  
  desc "Check customers with line off and create alerts (async)"
  task check_customers_with_line_off: :environment do
    CreateAlertsForLineOffJob.perform_later
  end
  
  desc "Pull topups from Steama (async)"
  task pull_topups: :environment do
    UpdateToupsJob.perform_later
  end

end
