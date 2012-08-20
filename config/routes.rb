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
    get :activate, :on => :member
  end

  resources( :home, :path => '/', :constraints => { :subdomain => /^(www)?$/ },
    :only => [:index, :dashboard] ) do
    get :dashboard, :on => :collection
  end

  resources(:classrooms, :path => '/', :constraints => { :subdomain => /.+/ },
    :only => [:dashboard] ) do
    # Route groups to own subdomains
    get :dashboard, :on => :collection, :path => '/'
  end

  # Route to homepage by default
  root :to => 'home#index'
end
