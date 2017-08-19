class AddStatusToAlerts < ActiveRecord::Migration[5.0]
  def change
    add_reference :alerts, :status, foreign_key: true
  end
end
