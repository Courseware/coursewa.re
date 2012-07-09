Courseware::Application.routes.draw do
  get 'logout' => 'sessions#destroy', :as => 'logout'
  get 'login' => 'sessions#new', :as => 'login'
  post 'login' => 'sessions#create', :as => 'login_post'
  get 'signup' => 'users#new', :as => 'signup'
  post 'signup' => 'users#create', :as => 'signup_post'

  resources :users, :only => [:new, :create] do
    member do
      get :activate
    end
  end

  resources :sessions, :only => [:new, :create, :destroy]

  root :to => 'home#index'
end
