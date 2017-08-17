require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

if Rails.env.in?(%w(test development))

  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end

  CarrierWave::Uploader::Base.descendants.each do |descendant|
    next if descendant.anonymous?
    descendant.class_eval do
      storage :file

      def cache_dir
        "#{Rails.root}/public/uploads/#{Rails.env}/tmp"
      end

      def store_dir
        "#{Rails.root}/public/uploads/#{Rails.env}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
      end
    end
  end

else

  CarrierWave.configure do |config|
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
        provider: "AWS",
        region: 'eu-west-2',
        aws_access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID'),
        aws_secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY')
        }
    config.fog_directory = ENV['FOG_DIRECTORY']
    config.fog_attributes = { 'Cache-Control' => "max-age=#{365.days.to_i}" }
  end

end