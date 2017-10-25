class AddFieldsToTopups < ActiveRecord::Migration[5.0]
  def change
    add_column :topups, :reference, :string, nul: false
    add_column :topups, :raw_message, :string
  end
end
