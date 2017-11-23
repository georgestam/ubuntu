class AddHiddenFromGraphsToAlerts < ActiveRecord::Migration[5.0]
  def change
    add_column :type_alerts, :hidden_from_graphs, :boolean, default: false
  end
end
