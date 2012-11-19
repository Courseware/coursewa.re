require 'spec_helper'

describe ImagesController do
  describe 'routing' do

    it 'for index' do
      get('http://test.lvh.me/images').should route_to('images#index')
    end

    it 'for creation' do
      post('http://test.lvh.me/images').should route_to('images#create')
    end

    it 'for deletion' do
      delete('http://test.lvh.me/images/1').should route_to(
        'images#destroy', :id => '1')
    end

  end
end
