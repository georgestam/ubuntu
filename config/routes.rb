Rails.application.routes.draw do

  # sidekiq setup
  require "sidekiq/web"
  authenticate :user, (lambda { |u| u.role == "manager" }) do
    mount Sidekiq::Web => '/sidekiq'
  end

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
    
  devise_for :users, controllers: { registrations: 'registrations', sessions: 'sessions' }
  
  resources  :alerts, only: %i(index show new create update) do
    collection do 
      get "select_issue_response"   # /alerts/select_issue_response
      get "select_alert_subgroup"   # /alerts/select_issue_subgroup
      get "select_issue" 
    end 
    
  end 
  
  resources :stats, only: %i(index create) do
    collection do 
      get "monthly_graphs"  
    end 
  end 

  get 'info', to: "pages#info"
  
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
