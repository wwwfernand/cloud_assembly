Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  root 'top#index'
  resources :users, only: :create
  post    'login',     to: 'user_sessions#create', constraints: { format: 'json' }
  delete  'logout',    to: 'user_sessions#destroy'

  scope module: "member" do
    get 'new',      to: 'articles#new'
    post 'new',     to: 'articles#create', as: :articles, constraints: { format: 'json' }
  end
  namespace :member do
    resources :articles, only: [:index, :edit, :update]
    resources :user_images, only: [:index, :create], constraints: { format: 'json' }
    resource :user, only: [:show, :update], path: :profile
  end

  get 'articles/:id',  	to: 'articles#show', 				as: :show_article
  get 'drafts/:id', 	to: 'drafts#show', 	only: :show,	as: :draft_article
  resources :users,  :path => :authors, param: :name, only: :show
end
