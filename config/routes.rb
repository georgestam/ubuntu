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
      post "graph_costumer"
      get "customer_list"
    end
  end

  resources :usages, only: %i() do
    collection do
      get "total_usage_and_custommer_with_usage_per_day"
      get "custommer_with_usage_per_week"
    end

  end

  get 'info', to: "pages#info"

  post "users/update_db"

  root to: 'users#index', as: :root
  get 'complate_last_10', to: "users#complate_last_10"

  namespace :api, defaults: { format: :json } do
    namespace :respira do
      namespace :v1 do
        resources :recordings, only: %i[index show update create destroy]
      end
    end
  end

end
