class CreateUsages < ActiveRecord::Migration[5.0]
  def change
    create_table :usages do |t|
      t.text :api_data, null: false 
      t.date :created_on, null: false 
      t.references :meter, null: false, foreign_key: true
      
      t.index [:meter_id, :created_on], unique: true # it ensures that a record is not created on the same day for the same user 

      t.timestamps
    end
  end
end
