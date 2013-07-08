require 'spec_helper'

describe Coursewareable::CollaborationsController do

  routes { Coursewareable::Engine.routes }

  describe 'routing' do
    it 'for deletion' do
      delete('http://test.lvh.me/collaborations/1').should route_to(
        'coursewareable/collaborations#destroy', :id => '1')
    end

    it 'for index listing' do
      get('http://test.lvh.me/collaborations').should route_to(
        'coursewareable/collaborations#index')
    end

    it 'for creation' do
      post('http://test.lvh.me/collaborations').should route_to(
        'coursewareable/collaborations#create')
    end
  end
end
