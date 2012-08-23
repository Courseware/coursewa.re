require 'spec_helper'

describe SessionsController do
  let(:user){ Fabricate(:user) }

  describe 'GET new' do
    subject{ get :new }
    it{ should render_template :new }
  end

  describe 'POST create' do
    context 'with invalid login' do
      subject{ post :create }
      it{ should render_template(:new) }
    end

    context 'with inactive account' do
      subject{ post :create, :email => user.email, :password => 'secret' }
      it{ should render_template(:new) }
    end

    context 'with active account' do
      before(:each){ user.activate! }
      subject{ post :create, :email => user.email, :password => 'secret' }
      it{ should redirect_to(dashboard_home_index_path) }
    end

  end

  describe 'DELETE :destroy' do
    subject{ delete :destroy }
    it{ should redirect_to(login_path) }
  end

end
