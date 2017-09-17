class AddUserReferencesToAlert < ActiveRecord::Migration[5.0]
  def change
    
    add_column :alerts, :created_by_id, :integer, foreign_key: true, index: true
    add_column :alerts, :user_id, :integer, foreign_key: true, index: true

    add_foreign_key :alerts, :users, column: :created_by_id
    add_foreign_key :alerts, :users, column: :user_id
  end
end
