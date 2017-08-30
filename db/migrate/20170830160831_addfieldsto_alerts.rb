class AddfieldstoAlerts < ActiveRecord::Migration[5.0]
  def change
    add_column :alerts, :resolved_at, :datetime
    add_column :alerts, :closed_at, :datetime
  end
end
