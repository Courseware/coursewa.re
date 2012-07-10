require 'spec_helper'

describe PasswordsController do
  describe 'routing' do

    it 'for recovery submition screen' do
      get('/passwords/new').should route_to('passwords#new')
    end

    it 'for recovery submition' do
      post('/passwords').should route_to('passwords#create')
    end

    it 'for update screen' do
      get('/passwords/token/edit').should route_to(
        'passwords#edit', :id => 'token'
      )
    end

    it 'for signup' do
      put('/passwords/token').should route_to(
        'passwords#update', :id => 'token'
      )
    end

  end
end
