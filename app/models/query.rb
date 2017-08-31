class Query < ApplicationRecord
  belongs_to :type_alert
  has_many :alerts 
  
  # to show text in rails admin
  validates :resolution, presence: true
  
  def name
    self.resolution
  end
end
