require 'spec_helper'

describe HomeController do
  describe 'routing' do

    it 'for landing page' do
      get('/').should route_to('home#index')
    end

    describe 'on a subdomain' do
      it 'goes to group langing page' do
        get('http://test.coursewa.re').should route_to('groups#show')
      end
    end

  end
end
