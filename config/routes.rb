Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  root 'top#index'
  resources :users, only: :create
  post    'login',     to: 'user_sessions#create', constraints: { format: 'json' }
  delete  'logout',    to: 'user_sessions#destroy'
  namespace :member do
    resource :user, only: [:show, :update], path: :profile
  end
  resources :users,  :path => :authors, param: :name, only: :show
end
