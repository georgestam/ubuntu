class AddUserToGroupAlerts < ActiveRecord::Migration[5.0]
  def change
    add_reference :group_alerts, :user, foreign_key: true
  end
end
