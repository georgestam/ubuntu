class Usage < ApplicationRecord
  belongs_to :meter
  
  validates: 
  
  validates: :meter, presence: true
  validates: :api_data, presence: true
  
  validates :created_on, uniqueness: {scope: :meter}, allow_nil: true
  
end
