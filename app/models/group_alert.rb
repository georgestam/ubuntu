class GroupAlert < ApplicationRecord
  has_many :type_alerts
  
  validates :title, presence: true
end
