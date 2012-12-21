require 'spec_helper'

describe Coursewareable::CollaborationsController do

  before do
    @routes = Coursewareable::Engine.routes
  end

  describe 'routing' do
    it 'for deletion' do
      delete('http://test.lvh.me/collaborations/1').should route_to(
        'coursewareable/collaborations#destroy', :id => '1')
    end
  end
end
