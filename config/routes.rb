Rails.application.routes.draw do

  resources :camps do
    member do
      post 'participate'
      delete 'quit'
    end
  end
  root 'static_pages#home'

  post '/fake_login', to: 'application#fake_login'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'

  get 'password_resets/new'
  get 'password_resets/edit'

  get '/login', to: "sessions#new"
  post '/login', to: "sessions#create"
  delete '/logout', to: "sessions#destroy"
  get '/signup', to: "users#new"
  post '/signup', to: "users#create"

  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :edit, :create, :update]
  resources :microposts do
    member do
      resources :buckets
      resources :comments
    end
  end

  resources :comments do
    collection do
      post 'read_all'
    end
  end

  resources :users do
    member do
      post :like_post
      delete :unlike_post
      get :following, :followers
    end
  end

  get '/notifications', to: 'users#notifications'

  resources :relationships, only: [:create, :destroy]
end
