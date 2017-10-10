class Topup < ApplicationRecord
  belongs_to :customer
  
  validates :customer, presence: true
  validates :value, :numericality => { :greater_than_or_equal_to => 1 }
  
end
