class CreateTopups < ActiveRecord::Migration[5.0]
  def change
    create_table :topups do |t|
      t.references :customer, foreign_key: true
      t.integer :amount, nul: false
      t.integer :id_steama, nul: false 
      t.datetime :created_on, null: false 

      t.timestamps
    end
  end
end
