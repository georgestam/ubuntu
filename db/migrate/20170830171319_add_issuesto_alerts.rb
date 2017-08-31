class AddIssuestoAlerts < ActiveRecord::Migration[5.0]
  def change
    add_reference :alerts, :issue, foreign_key: true
  end
end
