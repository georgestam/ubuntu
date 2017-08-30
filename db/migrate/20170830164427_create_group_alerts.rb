class CreateGroupAlerts < ActiveRecord::Migration[5.0]
  def change
    create_table :group_alerts do |t|
      t.string :title

      t.timestamps
    end
  end
end
