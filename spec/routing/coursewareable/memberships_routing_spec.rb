require 'spec_helper'

describe Coursewareable::MembershipsController do

  before do
    @routes = Coursewareable::Engine.routes
  end

  describe 'routing' do
    it 'for deletion' do
      delete('http://test.lvh.me/memberships/1').should route_to(
        'coursewareable/memberships#destroy', :id => '1')
    end
  end
end
