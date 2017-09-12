class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :reload_rails_admin, if: :rails_admin_path?
  skip_before_action :verify_authenticity_token

  include Pundit

  # Pundit: white-list approach.
  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  def skip_pundit? #  Pundit
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end

  def default_url_options
    { locale: I18n.locale == I18n.default_locale ? nil : I18n.locale }
  end

  private

  # https://github.com/sferik/rails_admin/wiki/How-to:-Reloading-RailsAdmin-Config-Automatically
  def reload_rails_admin
    models = %w(User UserProfile)
    models.each do |m|
      RailsAdmin::Config.reset_model(m)
    end
    RailsAdmin::Config::Actions.reset

    load("Rails.root.join('config', 'initializers', 'rails_admin.rb')")
  end

  def rails_admin_path?
    controller_path =~ /rails_admin/ && Rails.env.development?
  end

end
