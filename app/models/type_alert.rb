class TypeAlert < ApplicationRecord
  
  has_many :issues
  
  belongs_to :group_alert
  
  validates :name, presence: true
  
end
