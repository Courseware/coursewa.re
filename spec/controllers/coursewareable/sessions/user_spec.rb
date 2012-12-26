require 'spec_helper'

describe Coursewareable::SessionsController, :focus => true do
  let(:user) { Fabricate(:confirmed_user) }

  describe 'GET new' do
    before do
      @controller.send(:auto_login, user)
      get(:new, :use_route => :coursewareable)
    end

    it{ should redirect_to(me_users_url) }
  end

  describe 'POST create' do
    before(:each) do
      @controller.send(:auto_login, user)
      post(:create, :use_route => :coursewareable, :email => user.email,
           :password => 'secret')
    end

    it{ should redirect_to(me_users_url) }
  end

end
