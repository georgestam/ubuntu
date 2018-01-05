class AddUniqueIndexToBalances < ActiveRecord::Migration[5.0]
  def change
    add_index :balances, [:created_on, :customer_id], unique: true
  end
end
