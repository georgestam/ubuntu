class DropStatuses < ActiveRecord::Migration[5.0]
  def change
    # TODO: this table is not used anymore, but I get this error:
    # DETAIL:  constraint fk_rails_330229c251 on table alerts depends on table statuses
    #HINT:  Use DROP ... CASCADE to drop the dependent objects too.

    # drop_table :statuses
  end
end
