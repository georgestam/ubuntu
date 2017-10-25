class AddFieldsToTopups < ActiveRecord::Migration[5.0]
  def change
    add_column :topups, :reference, :integer
    add_column :topups, :raw_message, :string
  end
end
