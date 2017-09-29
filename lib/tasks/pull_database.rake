namespace :pull_database do
  desc "Pull Database from Steama and run alerts (async)"
  task update_all: :environment do
    UpdateDbJob.perform_later
  end
  
  desc "Pull usage from Steama (async)"
  task pull_usage: :environment do
    PullUsageJob.perform_later
  end

end
