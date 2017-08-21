class Recording < ApplicationRecord
  belongs_to :user
  
  mount_uploader :file, RecordUploader
  
  # serialize :data, JSON

end
