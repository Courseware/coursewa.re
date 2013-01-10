require 'spec_helper'

describe Coursewareable::SessionsController do
  describe 'GET new' do
    before{ get(:new, :use_route => :coursewareable) }
    it { should render_template :new }
  end

  describe 'POST create' do
    let(:user){ Fabricate('coursewareable/user') }

    before(:each) do
      post(:create, :use_route => :coursewareable, :email => user.email,
           :password => 'secret')
    end

    context 'with inactive account' do
      it { should render_template(:new) }
      its('flash.keys') { should include(:alert) }
    end

    context 'with invalid login' do
      let(:user) { Fabricate.build('coursewareable/user') }

      it { should render_template(:new) }
      its('flash.keys') { should include(:alert) }
    end

    context 'with activated account' do
      before(:all) { user.activate! }

      it { should redirect_to(root_path) }
    end

  end

  describe 'DELETE :destroy' do
    let(:user) { Fabricate(:confirmed_user) }
    before(:each) { delete(:destroy, :use_route => :coursewareable) }

    context 'when logged in' do
      before(:all) do
        setup_controller_request_and_response
        @controller.send(:auto_login, user)
      end

      it 'logs out' do
        should redirect_to(root_path)
        @controller.current_user.should be_nil
        flash.keys.should include(:notice)
      end
    end

    it { should redirect_to(login_path) }
  end

end

