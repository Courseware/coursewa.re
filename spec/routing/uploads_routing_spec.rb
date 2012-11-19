require 'spec_helper'

describe UploadsController do
  describe 'routing' do

    it 'for index' do
      get('http://test.lvh.me/uploads').should route_to('uploads#index')
    end

    it 'for creation' do
      post('http://test.lvh.me/uploads').should route_to('uploads#create')
    end

    it 'for deletion' do
      delete('http://test.lvh.me/uploads/1').should route_to(
        'uploads#destroy', :id => '1')
    end

  end
end
