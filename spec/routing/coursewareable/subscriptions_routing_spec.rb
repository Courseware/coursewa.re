require 'spec_helper'

describe Coursewareable::SubscriptionsController do
  before do
    @routes = Coursewareable::Engine.routes
  end

  describe 'routing' do
    it 'for new' do
      get('http://test.lvh.me/subscriptions/new').should route_to(
        'coursewareable/subscriptions#new')
    end

    it 'for create' do
      post('http://test.lvh.me/subscriptions').should route_to(
        'coursewareable/subscriptions#create')
    end
  end
end
