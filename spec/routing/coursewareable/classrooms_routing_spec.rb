require 'spec_helper'

describe Coursewareable::ClassroomsController do

  before do
    @routes = Coursewareable::Engine.routes
  end

  describe 'routing' do
    it 'for creation screen' do
      get('/start').should route_to('coursewareable/classrooms#new')
    end

    it 'for creation' do
      post('/start').should route_to('coursewareable/classrooms#create')
    end

    it 'for dashboard screen' do
      get('http://test.lvh.me/').should route_to(
        'coursewareable/classrooms#dashboard')
    end

    it 'for edit screen' do
      get('http://test.lvh.me/edit').should route_to(
        'coursewareable/classrooms#edit')
    end

    it 'for update' do
      put('http://test.lvh.me/').should route_to(
        'coursewareable/classrooms#update')
    end

    it 'for users suggestion' do
      get('http://test.lvh.me/suggest_user').should route_to(
        'coursewareable/users#suggest', :format => :json)
    end

  end
end
