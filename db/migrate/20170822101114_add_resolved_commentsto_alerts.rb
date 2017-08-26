class AddResolvedCommentstoAlerts < ActiveRecord::Migration[5.0]
  def change
    add_column :alerts, :resolved_comments, :string
  end
end
