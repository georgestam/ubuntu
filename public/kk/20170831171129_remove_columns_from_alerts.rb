class RemoveColumnsFromAlerts < ActiveRecord::Migration[5.0]
  def change
    # TODO: remove type alerts and status fields
    
    # remove_foreign_key :alerts, :type_alers
    # remove_foreign_key :alerts, :status
    
    # remove_column :alerts, :type_alerts
    remove_column :alerts, :description, :string
    # remove_column :alerts, :status
    remove_column :alerts, :resolved_comments, :string
  end
end
