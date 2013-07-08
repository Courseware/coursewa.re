require 'spec_helper'

describe Coursewareable::UploadsController do

  routes { Coursewareable::Engine.routes }

  describe 'routing' do
    it 'for index' do
      get('http://test.lvh.me/uploads').should route_to(
        'coursewareable/uploads#index')
    end

    it 'for creation' do
      post('http://test.lvh.me/uploads').should route_to(
        'coursewareable/uploads#create')
    end

    it 'for deletion' do
      delete('http://test.lvh.me/uploads/1').should route_to(
        'coursewareable/uploads#destroy', :id => '1')
    end
  end
end
