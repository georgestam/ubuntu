class Meter < ApplicationRecord
  belongs_to :customer
  has_many :usages, dependent: :destroy
  
  validates :customer, presence: true
  validates :customer, uniqueness: true
  
  def usages_on(date)
    usages.where(created_on: date)
  end 
  
end
