require 'spec_helper'

describe Coursewareable::UsersController do

  describe 'GET new' do
    context 'not logged in' do
      before{ get(:new, :use_route => :coursewareable) }
      it { should render_template(:new) }
    end

    context 'when logged in' do
      before do
        @controller.send(:auto_login, Fabricate('coursewareable/user'))
        get(:new, :use_route => :coursewareable)
      end

      it { should redirect_to(root_path) }
    end
  end

  describe 'POST create' do
    let(:user_attr) { Fabricate.build(:confirmed_user) }

    before(:each) do
      @old_emails_count = ActionMailer::Base.deliveries.count
      @old_users_count = Coursewareable::User.count

      post(:create, :use_route => :coursewareable, :user => {
        :email => user_attr.email, :password => user_attr.password,
        :password_confirmation => user_attr.password
      })
    end

    it 'creates the user' do
      Coursewareable::User.count.should eq(@old_users_count + 1)
      ActionMailer::Base.deliveries.count.should eq(@old_emails_count + 1)
      should redirect_to(root_path)
    end

    context 'missing required params' do
      let(:user_attr) do
        Fabricate.build(:confirmed_user, :email => nil, :password => nil,
                        :password_confirmation => nil)
      end

      it { should render_template(:new) }
      it { ActionMailer::Base.deliveries.count.should eq(@old_emails_count) }
      it { Coursewareable::User.count.should eq(@old_users_count) }
    end

    context 'when logged in' do
      before(:all) do
        setup_controller_request_and_response
        @controller.send(:auto_login, Fabricate('coursewareable/user'))
      end

      it { should redirect_to(login_path) }
      it { ActionMailer::Base.deliveries.count.should eq(@old_emails_count) }
      it { Coursewareable::User.count.should eq(@old_users_count) }
    end
  end

  describe 'GET activate' do
    let(:user) { Fabricate('coursewareable/user') }

    before do
      get(:activate, :use_route => :coursewareable,
          :id => user.activation_token)
      user.reload
    end

    subject { user }

    its(:activation_state) { should eq('active') }
    its('activities.last.key') { should eq('coursewareable_user.create') }
    it { should redirect_to(login_path) }
  end

  describe 'GET me' do
    let(:user){ Fabricate(:confirmed_user) }

    before do
      @controller.send(:auto_login, user)
      get(:me, :use_route => :coursewareable)
    end

    it { should render_template(:me) }
  end
end
