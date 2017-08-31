class TypeAlert < ApplicationRecord
  
  has_many :queries
  
  belongs_to :group_alert
  
  validates :name, presence: true
  
end
