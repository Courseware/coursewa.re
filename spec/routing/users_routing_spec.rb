require 'spec_helper'

describe UsersController do
  describe 'routing' do

    it 'for signup screen' do
      get('/users/new').should route_to('users#new')
      get('/signup').should route_to('users#new')
    end

    it 'for signup' do
      post('/users').should route_to('users#create')
      post('/signup').should route_to('users#create')
    end

    it 'for activation' do
      get('/users/token/activate').should route_to(
        'users#activate', :id => 'token'
      )
    end

    it 'for personal profile page' do
      get('/users/me').should route_to(
        'users#me'
      )
    end

    it 'for personal profile page updates' do
      put('/users/1').should route_to(
        'users#update', :id => '1'
      )
    end

  end
end
