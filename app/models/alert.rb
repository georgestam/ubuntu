class Alert < ApplicationRecord
  belongs_to :customer
  belongs_to :type_alert
  
  validates :customer, presence: true
  
  def self.users_with_negative_acount
    Customer.all.each do |customer|
      if customer.account_balance.to_i <= 0 
        if Alert.create!({
          customer_id: customer.id,
          type_alert_id: TypeAlert.first.id, # this alert is 'nagative_account'
          description: "User has negative account",
          open: true
          })
        else 
          #to do send an error
        end 
      end 
    end
  end 

end
