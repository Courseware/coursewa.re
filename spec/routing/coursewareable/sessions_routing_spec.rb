require 'spec_helper'

describe Coursewareable::SessionsController do

  routes { Coursewareable::Engine.routes }

  describe 'routing' do
    it 'for authentication screen' do
      get('/sessions/new').should route_to('coursewareable/sessions#new')
      get('/login').should route_to('coursewareable/sessions#new')
    end

    it 'for authentication' do
      post('/sessions').should route_to('coursewareable/sessions#create')
      post('/login').should route_to('coursewareable/sessions#create')
    end

    it 'for signing out' do
      delete('/sessions/1').should route_to(
        'coursewareable/sessions#destroy', :id => '1'
      )
      get('/logout').should route_to('coursewareable/sessions#destroy')
    end
  end
end
