class AddPermisionsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :manager, :string, default: "field"
  end
end
