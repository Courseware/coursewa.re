Courseware::Application.routes.draw do

  get 'signup' => 'users#new', :as => 'signup'
  get 'login' => 'sessions#new', :as => 'login'
  get 'logout' => 'sessions#destroy', :as => 'logout'

  post 'signup' => 'users#create', :as => 'signup_post'
  post 'login' => 'sessions#create', :as => 'login_post'

  resources :sessions, :only => [:new, :create, :destroy]
  resources :passwords, :only => [
    :new, :create, :update, :edit
  ]
  resources :users, :only => [:new, :create] do
    member do
      get :activate
    end
  end

  # Route groups to own subdomains
  match '/' => 'groups#show', :constraints => { :subdomain => /.+/ }
  # Route to homepage by default
  root :to => 'home#index'
end
