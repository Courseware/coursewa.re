require 'spec_helper'

describe Coursewareable::MembershipsController do

  routes { Coursewareable::Engine.routes }

  describe 'routing' do
    it 'for deletion' do
      delete('http://test.lvh.me/memberships/1').should route_to(
        'coursewareable/memberships#destroy', :id => '1')
    end

    it 'for index listing' do
      get('http://test.lvh.me/memberships').should route_to(
        'coursewareable/memberships#index')
    end

    it 'for creation' do
      post('http://test.lvh.me/memberships').should route_to(
        'coursewareable/memberships#create')
    end
  end
end
