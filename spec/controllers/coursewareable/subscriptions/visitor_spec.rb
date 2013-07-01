require 'spec_helper'

describe Coursewareable::SubscriptionsController do
  describe 'GET new' do
    before do
      get(:new, :use_route => :coursewareable)
    end

    it{ should redirect_to(login_path) }
  end

  describe 'POST create' do
    before do
      post(:create, :plan => :micro,
        :stripeToken => 'tok_1RS9azWt0HFg1d', :use_route => :coursewareable)
    end

    it{ should redirect_to(login_path) }
  end
end
