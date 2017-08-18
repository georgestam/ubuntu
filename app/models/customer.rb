class Customer < ApplicationRecord
  
  validates :id_steama, presence: true, uniqueness: true
  
end
