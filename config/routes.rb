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

  resource(:home, :path => '/', :constraints => { :subdomain => false },
           :only => [:index] ) do
    get :dashboard
    get :about
    get :contact
    post :feedback
  end

  resource(:classroom, :path => '/', :constraints => { :subdomain => /.+/ },
    :only => [:edit, :update] ) do
    collection do
      get :dashboard, :path => '/'
      get 'suggest_user' => 'users#suggest', :defaults => { :format => :json }
      resources(:memberships, :only => [:destroy])
      resources(:collaborations, :only => [:destroy])
      resource(:syllabus, :only => [:show, :edit, :update, :create])
      resources(:images, :only => [:index, :create, :destroy])
      resources(:uploads, :only => [:index, :create, :destroy])
      resources(:lectures, :except => [:index]) do
        resources(:assignments, :except => [:index]) do
          resources(:grades, :only => [
            :index, :new, :create, :destroy, :edit, :update])
          resources(:responses, :only => [:new, :create, :destroy, :show])
        end
      end
    end
  end

  # Route to homepage by default
  root :to => 'homes#index'
end

Courseware::Application.routes.draw do
  # Route overwrites come below:

  # Mount the Coursewareable Engine
  mount Coursewareable::Engine => '/'
end
