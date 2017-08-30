class AddGroupAlertToTypeAlerts < ActiveRecord::Migration[5.0]
  def change
    add_reference :type_alerts, :group_alert, foreign_key: true
  end
end
