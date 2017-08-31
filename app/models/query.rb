class Query < ApplicationRecord
  belongs_to :type_alert
  has_many :alerts 
  
  # to show text in rails admin
  def name
    self.resolution
  end
end
