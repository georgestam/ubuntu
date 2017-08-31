class AddQueriestoAlerts < ActiveRecord::Migration[5.0]
  def change
    add_reference :alerts, :query, foreign_key: true
  end
end
