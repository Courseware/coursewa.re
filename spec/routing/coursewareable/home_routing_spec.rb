require 'spec_helper'

describe Coursewareable::HomeController do

  before do
    @routes = Coursewareable::Engine.routes
  end

  describe 'routing' do
    it 'for landing page' do
      get('/').should route_to('coursewareable/home#index')
    end

    it 'for dashboard' do
      get('/dashboard').should route_to('coursewareable/home#dashboard')
    end

    describe 'on a subdomain' do
      it 'goes to classroom langing page' do
        get('http://test.lvh.me').should route_to('coursewareable/classrooms#dashboard')
      end
    end
  end
end
