class AddIgnoreAlertsToCustomers < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :ignore_alerts, :boolean, default: false
  end
end
