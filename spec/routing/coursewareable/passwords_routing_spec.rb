require 'spec_helper'

describe Coursewareable::PasswordsController do

  routes { Coursewareable::Engine.routes }

  describe 'routing' do
    it 'for recovery submition screen' do
      get('/passwords/new').should route_to('coursewareable/passwords#new')
    end

    it 'for recovery submition' do
      post('/passwords').should route_to('coursewareable/passwords#create')
    end

    it 'for update screen' do
      get('/passwords/token/edit').should route_to(
        'coursewareable/passwords#edit', :id => 'token'
      )
    end

    it 'for signup' do
      put('/passwords/token').should route_to(
        'coursewareable/passwords#update', :id => 'token'
      )
    end
  end
end
