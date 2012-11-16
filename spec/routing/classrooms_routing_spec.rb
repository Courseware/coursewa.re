require 'spec_helper'

describe ClassroomsController do
  describe 'routing' do

    it 'for creation screen' do
      get('/start').should route_to('classrooms#new')
    end

    it 'for creation' do
      post('/start').should route_to('classrooms#create')
    end

    it 'for dashboard screen' do
      get('http://test.lvh.me/').should route_to('classrooms#dashboard')
    end

  end
end
