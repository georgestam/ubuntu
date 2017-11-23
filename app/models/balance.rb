class Balance < ApplicationRecord
  belongs_to :customer
  
  validates :value_cents, presence: true
  validates :customer, presence: true
  
  validates :created_on, uniqueness: {scope: :customer}
  
  def self.update_balance
    Customer.all.each do |customer|
      
      balance = Balance.new(customer: customer, value_cents: customer.account_balance.to_i * 100, created_on: Time.zone.today)
      
      unless balance.save
        #  TODO: send email with error
      end
    end 
  end 
  
end
