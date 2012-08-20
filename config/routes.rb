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

  resources( :home, :path => '/', :constraints => { :subdomain => /^(www)?$/ },
    :only => [:index, :dashboard] ) do
    get :dashboard, :on => :collection
  end
  end

  # Route groups to own subdomains
  match '/' => 'classrooms#show', :constraints => { :subdomain => /.+/ }
  # Route to homepage by default
  root :to => 'home#index'
end
