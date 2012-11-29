require 'spec_helper'

describe Coursewareable::SessionsController do
  let(:user){ Fabricate('coursewareable/user') }

  describe 'GET new' do
    subject{ get :new, :use_route => :coursewareable }
    it{ should render_template :new }
  end

  describe 'POST create' do
    context 'with invalid login' do
      subject{ post :create, :use_route => :coursewareable }
      it{ should render_template(:new) }
    end

    context 'with inactive account' do
      subject{ post :create, :use_route => :coursewareable,
               :email => user.email, :password => 'secret' }
      it{ should render_template(:new) }
    end

    context 'with active account' do
      before(:each){ user.activate! }
      subject{ post :create, :use_route => :coursewareable,
               :email => user.email, :password => 'secret' }
      it{ should redirect_to(home_index_path) }
    end

  end

  describe 'DELETE :destroy' do
    subject{ delete :destroy, :use_route => :coursewareable }
    it{ should redirect_to(login_path) }
  end

end
