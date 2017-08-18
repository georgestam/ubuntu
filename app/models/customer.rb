class Customer < ApplicationRecord
  
  validates :id_steama, presence: true, uniqueness: true
  
  def self.customer_id_exist?(id_steama)
    true if Customer.find_by(id_steama: id_steama)
  end 
  
end
