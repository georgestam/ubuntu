class Issue < ApplicationRecord
  belongs_to :type_alert
  has_many :alerts 
  
  # to show text in rails admin
  validates :resolution, uniqueness: {scope: :type_alert}, allow_nil: true
  validates :type_alert, presence: true
  
  validate :solution_resolution_text_exist?
  
  def name
    self.resolution
  end
  
  def solution_resolution_text_exist?
    if self.resolution == "" || self.resolution.nil? 
      errors[:type_alert] << "#{self.id} An alert can be only marked as a resolved if it has a solution and a date resolved_at"
    end  
  end
  
end
