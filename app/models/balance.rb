class Balance < ApplicationRecord
  belongs_to :customer
  
  validates :value_cents, presence: true
  validates :customer, presence: true
  
  validates :created_on, uniqueness: {scope: :customer}, allow_nil: true
  
end
