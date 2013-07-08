require 'spec_helper'

describe Coursewareable::LecturesController do

  routes { Coursewareable::Engine.routes }

  describe 'routing' do
    it 'for new lecture' do
      get('http://test.lvh.me/lectures/new').should route_to(
        'coursewareable/lectures#new')
    end

    it 'for lecture' do
      get('http://test.lvh.me/lectures/test').should route_to(
        'coursewareable/lectures#show', :id => 'test')
    end

    it 'for creation screen' do
      get('http://test.lvh.me/lectures/test/edit').should route_to(
        'coursewareable/lectures#edit', :id => 'test')
    end

    it 'for creation' do
      post('http://test.lvh.me/lectures').should route_to(
        'coursewareable/lectures#create')
    end

    it 'for updating' do
      put('http://test.lvh.me/lectures/test').should route_to(
        'coursewareable/lectures#update', :id => 'test')
    end

    it 'for deletion' do
      delete('http://test.lvh.me/lectures/test').should route_to(
        'coursewareable/lectures#destroy', :id => 'test')
    end
  end
end
