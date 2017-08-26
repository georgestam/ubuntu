class AddAssignedtoToalerts < ActiveRecord::Migration[5.0]
  def change
    add_column :alerts, :assigned_to, :string
  end
end
