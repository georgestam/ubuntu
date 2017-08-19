class CreateAlerts < ActiveRecord::Migration[5.0]
  def change
    create_table :alerts do |t|
      t.references :customer, foreign_key: true
      t.references :type_alert, foreign_key: true
      t.string :description

      t.timestamps
    end
  end
end
