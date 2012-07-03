Courseware::Application.routes.draw do
  get 'logout' => 'sessions#destroy', :as => 'logout'
  get 'login' => 'sessions#new', :as => 'login'
  get 'signup' => 'users#new', :as => 'signup'

  resources :users, :only => [:new, :create]
  resources :sessions, :only => [:new, :create, :destroy]

  root :to => 'home#index'
end
