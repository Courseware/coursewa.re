require 'spec_helper'

describe ClassroomsController do
  describe 'routing' do

    it 'for classroom creation scree' do
      get('/start').should route_to('classrooms#new')
    end

  end
end
