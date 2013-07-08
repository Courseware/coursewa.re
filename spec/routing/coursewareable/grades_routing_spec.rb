require 'spec_helper'

describe Coursewareable::GradesController do

  routes { Coursewareable::Engine.routes }

  describe 'routing' do
    it 'for all grades' do
      get('http://test.lvh.me/lectures/l_id/assignments/a_id/grades').
        should(route_to('coursewareable/grades#index',
          :lecture_id => 'l_id', :assignment_id => 'a_id'))
    end

    it 'for new grade' do
      get('http://test.lvh.me/lectures/l_id/assignments/a_id/grades/new').
        should(route_to('coursewareable/grades#new',
          :lecture_id => 'l_id', :assignment_id => 'a_id'))
    end

    it 'for creation' do
      post('http://test.lvh.me/lectures/l_id/assignments/a_id/grades').
        should(route_to('coursewareable/grades#create',
          :lecture_id => 'l_id', :assignment_id => 'a_id'))
    end

    it 'for editing' do
      get('http://test.lvh.me/lectures/l_id/assignments/a_id/grades/99/edit').
        should(route_to('coursewareable/grades#edit',
          :lecture_id => 'l_id', :assignment_id => 'a_id', :id => '99'))
    end

    it 'for update' do
      put('http://test.lvh.me/lectures/l_id/assignments/a_id/grades/99').
        should(route_to('coursewareable/grades#update',
          :lecture_id => 'l_id', :assignment_id => 'a_id', :id => '99'))
    end

    it 'for deletion' do
      delete('http://test.lvh.me/lectures/l_id/assignments/a_id/grades/99').
        should(route_to('coursewareable/grades#destroy',
          :lecture_id => 'l_id', :assignment_id => 'a_id', :id => '99'))
    end
  end
end

