class Topup < ApplicationRecord
  belongs_to :customer
  
  validates :customer, presence: true
  validates :id_steama, presence: true
  validates :amount, :numericality => { :greater_than_or_equal_to => 1 }
  
end
