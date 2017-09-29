class Meter < ApplicationRecord
  belongs_to :customer
  has_many :usages, dependent: :destroy
  
  validates :customer, presence: true
  validates :customer, uniqueness: true
  
end
