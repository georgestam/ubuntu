class AddFileToRecordings < ActiveRecord::Migration[5.0]
  def change
    add_column :recordings, :file, :string
  end
end
