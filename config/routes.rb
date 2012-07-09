Courseware::Application.routes.draw do

  get 'signup' => 'users#new', :as => 'signup'
  get 'login' => 'sessions#new', :as => 'login'
  get 'logout' => 'sessions#destroy', :as => 'logout'

  post 'signup' => 'users#create', :as => 'signup_post'
  post 'login' => 'sessions#create', :as => 'login_post'

  resources :users, :only => [:new, :create] do
    member do
      get :activate
    end
  end

  resources :sessions, :only => [:new, :create, :destroy]

  root :to => 'home#index'
end
