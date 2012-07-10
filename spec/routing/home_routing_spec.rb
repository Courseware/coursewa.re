require 'spec_helper'

describe HomeController do
  describe 'routing' do

    it 'for landing page' do
      get('/').should route_to('home#index')
    end

  end
end
