class Customer < ApplicationRecord
  
  has_many :alerts, dependent: :destroy
  
  validates :id_steama, presence: true, uniqueness: true
  
  def self.customer_id_exist?(id_steama)
    true if Customer.find_by(id_steama: id_steama)
  end 
  
  def custom_label_method
    "#{self.first_name} #{self.last_name}"
  end
  
  def customer_description_does_not_exist_open?
    exist = true 
    Alert.all.each do |alert|
      if Alert.find_by(customer_id: self.id, description: "User has negative account")
        exist = false  
      end
    end 
    exist
  end
  
end
