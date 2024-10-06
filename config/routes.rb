Rails.application.routes.draw do
  # Define resources for tasks with a custom member route
  resources :tasks do
    member do
      patch 'toggle_complete'
    end
  end

  # Define resources for categories
  resources :categories

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA routes
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Root path route
  root "tasks#index"
end
