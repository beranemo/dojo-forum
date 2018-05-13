Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root 'posts#index'
  resources :posts, only: [:new, :create, :show, :destroy, :edit, :update] do
    resources :comments, only: [:create, :destroy, :edit, :update]
    member do
      post :favorite
      post :unfavorite
    end
  end
  
  namespace :admin do
    resources :categories
    resources :users, only: [:index] do
      member do
        post :to_admin
        post :to_normal
      end
    end
  end
  
  resources :users, only: [:show, :edit, :update] do
    member do
      get :posts
      get :comments
      get :collects
    end
  end
  
  resources :friendships, only: [:create, :destroy]
  
end
