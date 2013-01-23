require 'spec_helper'

describe Coursewareable::FilesController do

  before do
    @routes = Coursewareable::Engine.routes
  end

  describe 'routing' do
    it 'for index' do
      get('http://test.lvh.me/files').should route_to(
        'coursewareable/files#index')
    end

    it 'for deletion' do
      delete('http://test.lvh.me/files/1').should route_to(
        'coursewareable/files#destroy', :id => '1')
    end
  end
end
