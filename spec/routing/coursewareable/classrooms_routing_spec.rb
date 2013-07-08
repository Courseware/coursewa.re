require 'spec_helper'

describe Coursewareable::ClassroomsController do

  routes { Coursewareable::Engine.routes }

  describe 'routing' do
    it 'for creation screen' do
      get('/start').should route_to('coursewareable/classrooms#new')
    end

    it 'for creation' do
      post('/start').should route_to('coursewareable/classrooms#create')
    end

    it 'for staff screen' do
      get('http://test.lvh.me/staff').should route_to(
        'coursewareable/classrooms#staff')
    end

    it 'for stats screen' do
      get('http://test.lvh.me/stats').should route_to(
        'coursewareable/classrooms#stats')

      get('http://test.lvh.me/stats.json').should route_to(
        'coursewareable/classrooms#stats', :format => 'json')
    end

    it 'for dashboard screen' do
      get('http://test.lvh.me/').should route_to(
        'coursewareable/classrooms#dashboard')
    end

    it 'for edit screen' do
      get('http://test.lvh.me/edit').should route_to(
        'coursewareable/classrooms#edit')
    end

    it 'for update' do
      put('http://test.lvh.me/').should route_to(
        'coursewareable/classrooms#update')
    end

    it 'for announcements' do
      post('http://test.lvh.me/announce').should route_to(
        'coursewareable/classrooms#announce')
    end

  end
end
