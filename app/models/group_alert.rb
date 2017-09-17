class GroupAlert < ApplicationRecord
  has_many :type_alerts

  belongs_to :user
  
  validates :title, presence: true
  validates :user, presence: true
  
end
