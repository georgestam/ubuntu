class RemoveColumnToAlerts < ActiveRecord::Migration[5.0]
  def change
    # TODO: remove status fields
    
    # remove_foreign_key :alerts, :status
    # remove_column :alerts, :status
    
    remove_column :alerts, :description, :string
    remove_column :alerts, :created_by, :string
    remove_column :alerts, :assigned_to, :string
  end
end
