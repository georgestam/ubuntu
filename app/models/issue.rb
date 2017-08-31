class Issue < ApplicationRecord
  belongs_to :type_alert
  has_many :alerts 
  
  # to show text in rails admin
  validates :resolution, uniqueness: {scope: :type_alert}, allow_nil: true
  validates :type_alert, presence: true
  
  def name
    self.resolution
  end
end
