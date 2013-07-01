require 'spec_helper'
require 'stripe_mock'

describe Coursewareable::SubscriptionsController do
  let(:user) { Fabricate(:confirmed_user) }

  describe 'GET new' do
    before do
      @controller.send(:auto_login, user)
      get(:new, :use_route => :coursewareable)
    end

    it{ should render_template(:new) }
  end

  describe 'POST create' do
    before do
      @controller.send(:auto_login, user)
      StripeMock.start
      post(:create, :plan => :micro,
        :stripeToken => 'tok_1RS9azWt0HFg1d', :use_route => :coursewareable)
    end

    after { StripeMock.stop }

    it 'should change user plan' do
      user.reload
      user.plan.slug.should eq('micro')
    end
    #TODO: check if Stripe Customer is created
  end
end
