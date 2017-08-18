class CreateCustomers < ActiveRecord::Migration[5.0]
  def change
    create_table :customers do |t|
      
      t.integer :id_steama, null: false 
      t.string :url 
      t.string :transactions_url
      t.string :utilities
      t.string :telephone
      t.string :first_name
      t.string :last_name
      t.string :account_balance
      t.string :low_balance_warning
      t.string :low_balance_level
      t.integer :site_manager
      t.string :site_manager_url
      t.string :site_manager_telephone
      t.integer :site
      t.string :site_url
      t.string :site_name
      t.integer :bit_harvester
      t.string :bit_harvester_url
      t.string :bit_harvester_telephone
      t.string :control_type
      t.string :line_number
      t.boolean :is_user
      t.boolean :is_agent
      t.boolean :is_site_manager
      t.boolean :is_field_manager
      t.boolean :is_demo
      t.string :language
      t.string :TOU_hours
      t.string :payment_plan
      t.string :integration_id
      t.string :labels

      t.timestamps
    end
  end
end


