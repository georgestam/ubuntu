class Alert < ApplicationRecord
  belongs_to :customer
  belongs_to :type_alert
  
  validates :customer, presence: true
  
  def self.check_customers_with_negative_acount
    Customer.all.each do |customer|
      if customer.account_balance.to_i <= 0 
        if Alert.create!({
            customer_id: customer.id,
            type_alert_id: TypeAlert.first.id, # this alert is 'nagative_account'
            description: "User has negative account",
            open: true
            })
        else 
          # flash[:alert] = alert.errors.full_messages
          # TODO: send email with there has been a problem
        end 
      end 
    end
  end 

end
