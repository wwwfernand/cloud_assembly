Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  root   'top#index'
  get    'about',           to: 'top#about'
  get    'privacy-policy',  to: 'top#privacy_policy'
  get    'terms-of-use',    to: 'top#terms_of_use'
  resource :contact_us, path: 'contact-us', only: [:new, :create]

  resources :users, only: :create
  post    'login',     to: 'user_sessions#create', constraints: { format: 'json' }
  delete  'logout',    to: 'user_sessions#destroy'

  scope module: 'member' do
    get 'new',      to: 'articles#new'
    post 'new',     to: 'articles#create', as: :articles, constraints: { format: 'json' }
  end
  namespace :member do
    resources :articles, only: %i[index edit update]
    resources :user_images, only: %i[index create], constraints: { format: 'json' }
    resource :user, only: %i[show update], path: :profile
  end

  get 'articles/:id', to: 'articles#show', as: :show_article
  get 'drafts/:id', only: :show, to: 'drafts#show', as: :draft_article
  resources :article_tags, path: :tags, param: :name, only: :show
  resources :users, path: :authors, param: :name, only: :show
end
