require 'spec_helper'

describe Coursewareable::HomesController do

  before do
    @routes = Coursewareable::Engine.routes
  end

  describe 'routing' do
    it 'for landing page' do
      get('/').should route_to('coursewareable/homes#index')
    end

    it 'for dashboard' do
      get('/dashboard').should route_to('coursewareable/homes#dashboard')
    end

    it 'for about page' do
      get('/about').should route_to('coursewareable/homes#about')
    end

    it 'for contact page' do
      get('/contact').should route_to('coursewareable/homes#contact')
    end

    describe 'on a subdomain' do
      it 'goes to classroom langing page' do
        get('http://test.lvh.me').should route_to(
          'coursewareable/classrooms#dashboard')
      end
    end
  end
end
