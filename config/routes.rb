Rails.application.routes.draw do
  root "static_page#home"
  
  get "search", to: "static_page#search"

  devise_for :users
  resources :users
  resources :movies do
    collection do
      get :top
    end
    resources :reviews
  end
  namespace :admin do
    resources :users
    resources :movies
    resources :reviews
    resources :comments
    resources :genres
    resources :descriptions
  end
  resources :like_reviews, only: :create
  resources :watchlists, only: [:create, :destroy]
end
