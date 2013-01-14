require 'spec_helper'

describe Coursewareable::SessionsController do
  let(:user) { Fabricate(:confirmed_user) }

  describe 'GET new' do
    before do
      @controller.send(:auto_login, user)
      get(:new, :use_route => :coursewareable)
    end

    it{ should redirect_to(root_path) }
  end

  describe 'POST create' do
    before(:each) do
      @controller.send(:auto_login, user)
      post(:create, :use_route => :coursewareable, :email => user.email,
           :password => 'secret')
    end

    it{ should redirect_to(root_path) }
  end

end
