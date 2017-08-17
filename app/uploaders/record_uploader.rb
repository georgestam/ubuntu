class RecordUploader < CarrierWave::Uploader::Base

  # storage :file
  
  storage :fog unless Rails.env.in?(%w(test development))

end
