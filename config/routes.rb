Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root 'posts#index'
  resources :posts, only: [:index, :new, :create, :show, :destroy, :edit, :update] do
    resources :comments, only: [:create, :destroy, :edit, :update]
    member do
      post :favorite
      post :unfavorite
      post :template_unfavorite
    end
    collection do
      get :feeds
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
      get :friends
      get :drafts
    end
  end
  
  resources :friendships, only: [:create, :destroy] do
    member do
      delete :reject
    end
  end
  
  resources :categories, only: [:show]
  
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      
      post "/login" => "auth#login"
      post "/logout" => "auth#logout"
      
      resources :posts, only: [:index, :show, :create, :update, :destroy]
    end
  end
  
end
