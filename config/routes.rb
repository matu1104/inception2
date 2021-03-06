TwitterApp::Application.routes.draw do
  devise_for :users

  resources :favorites
  root to: 'home#index'
  resources :users

  get 'tweets/:hash', to: 'tweets#index'
  get '/home//:hash', to: 'home#index', as: 'search_hash'
  get '/home/error', to: 'home#index', as: 'error'

  devise_scope :users do
    match 'users/sign_in' => 'devise/sessions#new', as: :login
  end

end
