namespace :pull_database do
  desc "Pull Database from Steama and run alerts (async)"
  task update_all: :environment do
    UpdateDbJob.perform_later
  end

end
