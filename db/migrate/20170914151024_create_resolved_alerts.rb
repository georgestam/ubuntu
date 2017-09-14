class CreateResolvedAlerts < ActiveRecord::Migration[5.0]
  def change
    create_table :resolved_alerts do |t|

      t.timestamps
    end
  end
end
