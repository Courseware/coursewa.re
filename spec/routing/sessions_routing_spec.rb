require 'spec_helper'

describe SessionsController do
  describe 'routing' do

    it 'for authentication screen' do
      get('/sessions/new').should route_to('sessions#new')
      get('/login').should route_to('sessions#new')
    end

    it 'for authentication' do
      post('/sessions').should route_to('sessions#create')
      post('/login').should route_to('sessions#create')
    end

    it 'for signing out' do
      delete('/sessions/1').should route_to(
        'sessions#destroy', :id => '1'
      )
      get('/logout').should route_to('sessions#destroy')
    end

  end
end
