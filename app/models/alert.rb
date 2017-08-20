class Alert < ApplicationRecord
  belongs_to :customer
  belongs_to :type_alert
  belongs_to :status
  
  validates :customer, presence: true
  
  after_create :send_alert_email

  def send_alert_email
    AlertMailer.perform(self).deliver_later
  end
  
  def self.check_customers_with_negative_acount
    Customer.all.each do |customer|
      if customer.account_balance.to_i <= 0 && customer.customer_description_does_not_exist_open?
        if Alert.create!({
            customer: customer,
            type_alert: TypeAlert.first, # this alert is 'nagative_account'
            description: "User has negative account",
            status: Status.first,
            created_by: User.first
            })
        else 
          # flash[:alert] = alert.errors.full_messages
          # TODO: send email with there has been a problem
        end 
      end 
    end
  end  

end
