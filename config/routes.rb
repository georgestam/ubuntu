Rails.application.routes.draw do
  
  # sidekiq setup
  require "sidekiq/web"
  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
    
  devise_for :users, controllers: { registrations: 'registrations', sessions: 'sessions' }
  
  resources  :users, only: %i(index)
  
  post "users/update_db"
  
  root to: 'users#index', as: :root
  
  namespace :api, defaults: { format: :json } do
    namespace :respira do
      namespace :v1 do
        resources :recordings, only: %i[index show update create destroy]
      end
    end
  end
  
end
