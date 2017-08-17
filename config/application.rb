require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'
require 'carrierwave'
require 'carrierwave/orm/activerecord'
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ubuntu
  class Application < Rails::Application
    eval File.read(Rails.root.join('config', 'initializers', 'global_functions.rb'))

    def self.host
      if development_or_test?
        'localhost'
      elsif staging?
        'https://ubuntu-power.herokuapp.com'
      else
        'https://ubuntu-power.herokuapp.com'
      end
    end

    def self.port
      if test?
        @@application_port ||= "5#{1000 + (Random.rand * 8999).to_i}".to_i
      elsif development?
        3000
      end
    end

    def self.protocol
      if development_or_test?
        'http'
      else
        'https'
      end
    end

    def self.set_url_options!
      [
        config.action_controller.default_url_options,
        config.action_mailer.default_url_options,
        Rails.application.routes.default_url_options,
        Devise::Engine.routes.default_url_options
      ].each do |config|

        config[:host] = host
        config[:port] = port if port
        config[:protocol] = protocol
        config[:only_path] = false

      end
    end

    config.i18n.default_locale = :en
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '*.{rb,yml}').to_s]

    config.generators do |generate|
      generate.assets false
    end

    config.active_record.time_zone_aware_types = [:datetime]

    config.assets.precompile += Ckeditor.assets
    config.assets.precompile += %w[ckeditor/*]
    config.autoload_paths += %W[#{config.root}/app/models/ckeditor]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
