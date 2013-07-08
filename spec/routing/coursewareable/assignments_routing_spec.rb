require 'spec_helper'

describe Coursewareable::AssignmentsController do

  routes { Coursewareable::Engine.routes }

  describe 'routing' do
    it 'for new assignment' do
      get('http://test.lvh.me/lectures/testy/assignments/new').should(
        route_to('coursewareable/assignments#new', :lecture_id => 'testy'))
    end

    it 'for assignment' do
      get('http://test.lvh.me/lectures/testy/assignments/test').should(
        route_to('coursewareable/assignments#show', :id => 'test',
          :lecture_id => 'testy'))
    end

    it 'for creation screen' do
      get('http://test.lvh.me/lectures/testy/assignments/test/edit').should(
        route_to('coursewareable/assignments#edit', :id => 'test',
          :lecture_id => 'testy'))
    end

    it 'for creation' do
      post('http://test.lvh.me/lectures/testy/assignments').should(
        route_to('coursewareable/assignments#create', :lecture_id => 'testy'))
    end

    it 'for updating' do
      put('http://test.lvh.me/lectures/testy/assignments/test').should(
        route_to('coursewareable/assignments#update', :id => 'test',
          :lecture_id => 'testy'))
    end

    it 'for deletion' do
      delete('http://test.lvh.me/lectures/testy/assignments/test').should(
        route_to('coursewareable/assignments#destroy', :id => 'test',
          :lecture_id => 'testy'))
    end
  end
end
