class UpdateToupsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Topup.update_topups_from_api
  end
end
