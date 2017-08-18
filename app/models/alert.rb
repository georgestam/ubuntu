class Alert < ApplicationRecord
  belongs_to :customer
  belongs_to :type_alert
  
  validates :customer, presence: true
end
