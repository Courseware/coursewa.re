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
      get('http://test.lvh.me/').should route_to('coursewareable/classrooms#dashboard')
    end

  end
end
