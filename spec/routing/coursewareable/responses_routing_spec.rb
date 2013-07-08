require 'spec_helper'

describe Coursewareable::ResponsesController do

  routes { Coursewareable::Engine.routes }

  describe 'routing' do
    it 'for new response' do
      get('http://test.lvh.me/lectures/l_id/assignments/a_id/responses/new').
        should(route_to('coursewareable/responses#new',
          :lecture_id => 'l_id', :assignment_id => 'a_id'))
    end

    it 'for response' do
      get('http://test.lvh.me/lectures/l_id/assignments/a_id/responses/99').
        should(route_to('coursewareable/responses#show',
          :lecture_id => 'l_id', :assignment_id => 'a_id', :id => '99'))
    end

    it 'for creation' do
      post('http://test.lvh.me/lectures/l_id/assignments/a_id/responses').
        should(route_to('coursewareable/responses#create',
          :lecture_id => 'l_id', :assignment_id => 'a_id'))
    end

    it 'for deletion' do
      delete('http://test.lvh.me/lectures/l_id/assignments/a_id/responses/99').
        should(route_to('coursewareable/responses#destroy',
          :lecture_id => 'l_id', :assignment_id => 'a_id', :id => '99'))
    end
  end
end
