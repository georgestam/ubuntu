class CreateIssues < ActiveRecord::Migration[5.0]
  def change
    create_table :issues do |t|
      t.references :type_alert, foreign_key: true
      t.string :resolution

      t.timestamps
    end
  end
end
