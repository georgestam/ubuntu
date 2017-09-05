class AddPermisionsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :role, :string, default: "field_user"
    add_column :users, :name, :string
  end
end
