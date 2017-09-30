class Meter < ApplicationRecord
  belongs_to :customer
  has_many :usages, dependent: :destroy
  
  validates :customer, presence: true
  validates :customer, uniqueness: true 
  
  def usages_this_month(month)
    array_usages = []
    Usage.where(meter: self).each do |usage|
      if usage.created_on.month == month 
        array_usages << usage 
      end 
    end
    array_usages  
  end 
  
end
