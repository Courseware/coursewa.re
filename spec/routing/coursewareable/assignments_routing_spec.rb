require 'spec_helper'

describe Coursewareable::AssignmentsController do

  before do
    @routes = Coursewareable::Engine.routes
  end

  describe 'routing' do
    it 'for new assignment' do
      get('http://test.lvh.me/assignments/new').should route_to(
        'coursewareable/assignments#new')
    end

    it 'for assignment' do
      get('http://test.lvh.me/assignments/test').should route_to(
        'coursewareable/assignments#show', :id => 'test')
    end

    it 'for creation screen' do
      get('http://test.lvh.me/assignments/test/edit').should route_to(
        'coursewareable/assignments#edit', :id => 'test')
    end

    it 'for creation' do
      post('http://test.lvh.me/assignments').should route_to(
        'coursewareable/assignments#create')
    end

    it 'for updating' do
      put('http://test.lvh.me/assignments/test').should route_to(
        'coursewareable/assignments#update', :id => 'test')
    end

    it 'for deletion' do
      delete('http://test.lvh.me/assignments/test').should route_to(
        'coursewareable/assignments#destroy', :id => 'test')
    end
  end
end
