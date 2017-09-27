class TypeAlert < ApplicationRecord
  
  has_many :issues
  has_many :alerts
  
  belongs_to :group_alert
  
  validates :name, presence: true
  
end
