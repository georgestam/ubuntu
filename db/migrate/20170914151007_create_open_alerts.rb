class CreateOpenAlerts < ActiveRecord::Migration[5.0]
  def change
    create_table :open_alerts do |t|

      t.timestamps
    end
  end
end
