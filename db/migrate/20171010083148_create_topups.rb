class CreateTopups < ActiveRecord::Migration[5.0]
  def change
    create_table :topups do |t|
      t.references :customer, foreign_key: true
      t.integer :value, nul: false 
      t.date :created_on, null: false 

      t.timestamps
    end
  end
end
