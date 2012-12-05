Coursewareable::Engine.routes.draw do
  get 'signup' => 'users#new', :as => 'signup'
  get 'login' => 'sessions#new', :as => 'login'
  get 'logout' => 'sessions#destroy', :as => 'logout'

  post 'signup' => 'users#create', :as => 'signup_post'
  post 'login' => 'sessions#create', :as => 'login_post'

  get 'start' => 'classrooms#new', :as => 'start_classroom'
  post 'start' => 'classrooms#create', :as => 'start_classroom_post'

  resources :sessions, :only => [:new, :create, :destroy]
  resources :passwords, :only => [
    :new, :create, :update, :edit
  ]
  resources :users, :only => [:new, :create, :update] do
    get :activate, :on => :member
    get :me, :on => :collection
  end

  resources( :home, :path => '/', :constraints => { :subdomain => /^(www)?$/ },
    :only => [:index, :dashboard] ) do
    get :dashboard, :on => :collection
  end

  resources(:classrooms, :path => '/', :constraints => { :subdomain => /.+/ },
    :only => [:dashboard] ) do
    collection do
      get :dashboard, :path => '/'
      resource(:syllabus, :only => [:show, :edit, :update, :create])
      resources(:images, :only => [:index, :create, :destroy])
      resources(:uploads, :only => [:index, :create, :destroy])
      resources(
        :lectures, :only => [:new, :show, :edit, :update, :create, :destroy])
    end
  end

  # Route to homepage by default
  root :to => 'home#index'
end

Courseware::Application.routes.draw do
  # Route overwrites come below:

  # Mount the Coursewareable Engine
  mount Coursewareable::Engine => '/'
end
