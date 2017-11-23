class CreateBalances < ActiveRecord::Migration[5.0]
  def change
    create_table :balances do |t|
      t.references :customer, foreign_key: true, null: false
      t.integer :value_cents, null: false
      t.date :created_on, null: false

      t.timestamps
    end
  end
end
