require 'spec_helper'

describe Coursewareable::UsersController do

  describe 'GET new' do
    before{ get(:new, :use_route => :coursewareable) }

    context 'not logged in' do
      it { should render_template(:new) }
    end

    context 'when logged in' do
      before(:all) do
        setup_controller_request_and_response
        @controller.send(:auto_login, Fabricate('coursewareable/user'))
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
    its('activities_as_owner.last.key') {
      should eq('coursewareable_user.create') }
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

  describe 'GET suggest' do
    let(:query) { Faker::HipsterIpsum.word }

    before(:each) do
      get(:suggest, :use_route => :coursewareable, :query => query)
    end

    context 'not logged in' do
      it { should redirect_to(login_path) }
    end

    shared_examples 'validates empty suggestion json' do
      it { subject['query'].should eq(query) }
      it { subject['suggestions'].should be_empty }
    end

    context 'when logged in' do
      before(:all) do
        setup_controller_request_and_response
        @controller.send(:auto_login, Fabricate(:confirmed_user))
      end

      shared_examples 'validates suggestion json' do
        it do
          subject['query'].should eq(query)
          subject['suggestions'].size.should eq(1)
          subject['suggestions'].first['value'].should eq(user.name)
          subject['suggestions'].first['user_id'].should eq(user.id)
          subject['suggestions'].first['pic'].should eq(
            GravatarImageTag::gravatar_url(user.email, :size => 30))
        end
      end

      subject { JSON.parse(response.body) }

      include_examples 'validates empty suggestion json'

      context 'a user to be suggested exists' do
        let(:user) { Fabricate(:confirmed_user) }

        context 'and query is too short' do
          let(:query) { user.name[0..1] }

          include_examples 'validates empty suggestion json'
        end

        context 'and query is a relevant name' do
          let(:query) { user.name[0..3] }

          include_examples 'validates suggestion json'
        end

        context 'and query is a relevant email' do
          let(:query) { user.email }

          include_examples 'validates suggestion json'
        end
      end

    end
  end
end
