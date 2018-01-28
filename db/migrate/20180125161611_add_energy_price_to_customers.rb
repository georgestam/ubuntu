class AddEnergyPriceToCustomers < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :energy_price, :string, nul: false
  end
end
