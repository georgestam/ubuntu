class CreateRecordings < ActiveRecord::Migration[5.0]
  def change
    create_table :recordings do |t|

      t.string :data, null: false 
      t.text :array_data, array: true, default: []

      t.timestamps
    end
  end
end
