require 'spec_helper'

describe Coursewareable::HomesController do
  let(:user) { Fabricate(:confirmed_user) }

  describe 'GET index' do
    before { get(:index, :use_route => :coursewareable) }

    it { should render_template(:index) }

    context 'when logged in' do
      before(:all) do
        setup_controller_request_and_response
        @controller.send(:auto_login, user)
      end

      it { should redirect_to(dashboard_home_path) }
    end
  end

  describe 'GET dashboard' do
    before { get(:dashboard, :use_route => :coursewareable) }
    it { should redirect_to(login_path) }

    context 'when logged in' do
      before(:all) do
        setup_controller_request_and_response
        @controller.send(:auto_login, user)
      end

      it { should render_template(:dashboard) }
    end
  end

  describe 'GET about' do
    before { get(:about, :use_route => :coursewareable) }
    it { should render_template(:about) }
  end

  describe 'GET contact' do
    before { get(:contact, :use_route => :coursewareable) }
    it { should render_template(:contact) }
  end

end
