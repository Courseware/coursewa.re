require 'spec_helper'

describe HomeController do
  describe 'routing' do

    it 'for landing page' do
      get('/').should route_to('home#index')
    end

    it 'for dashboard' do
      get('/dashboard').should route_to('home#dashboard')
    end

    describe 'on a subdomain' do
      it 'goes to classroom langing page' do
        get('http://test.lvh.me').should route_to('classrooms#dashboard')
      end
    end

  end
end
