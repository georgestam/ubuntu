class TypeAlert < ApplicationRecord
  
  has_many :alerts, dependent: :destroy
  
  validates :name, presence: true
  
end
