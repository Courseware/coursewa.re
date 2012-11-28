require 'spec_helper'

describe Coursewareable::UsersController do

  describe 'GET new' do
    context 'when user is not logged in' do
      subject{ get :new, :use_route => :coursewareable }
      it { should render_template(:new) }
    end

    context 'when user is logged in' do
      subject{ get :new, :use_route => :coursewareable }
      before{ @controller.send(:auto_login, Fabricate('coursewareable/user')) }
      it { should redirect_to(root_path) }
    end
  end

  describe 'POST create' do
    context 'missing params' do
      it 'should not create a new user' do
        users_count = Coursewareable::User.count
        emails_count = ActionMailer::Base.deliveries.count

        post :create, :use_route => :coursewareable

        response.should render_template(:new)
        ActionMailer::Base.deliveries.count.should eq(emails_count)
        Coursewareable::User.count.should eq(users_count)
      end
    end

    context 'when user is logged in' do
      it 'should not create a new user' do
      @controller.send(:auto_login, Fabricate('coursewareable/user'))

      users_count = Coursewareable::User.count
      emails_count = ActionMailer::Base.deliveries.count

      email = Faker::Internet.email
      passwd = Faker::Product.letters(8)

      post :create, :use_route => :coursewareable, :user => {
        :email => email,
        :password => passwd,
        :password_confirmation => passwd
      }

      ActionMailer::Base.deliveries.count.should eq(emails_count)
      Coursewareable::User.count.should eq(users_count)
      response.should redirect_to(login_path)
      end
    end

    it 'should create a new user' do
      users_count = Coursewareable::User.count
      emails_count = ActionMailer::Base.deliveries.count

      email = Faker::Internet.email
      passwd = Faker::Product.letters(8)

      post :create, :use_route => :coursewareable, :user => {
        :email => email,
        :password => passwd,
        :password_confirmation => passwd
      }

      ActionMailer::Base.deliveries.count.should_not eq(emails_count)
      Coursewareable::User.count.should_not eq(users_count)
      response.should redirect_to(root_path)
    end
  end

  describe 'GET activate' do
    it 'should handle user activation' do
      user = Fabricate('coursewareable/user')
      user.activation_state.should eq('pending')

      get :activate, :use_route => :coursewareable, :id => user.activation_token

      # Ignore any caches
      user.reload.activation_state.should eq('active')
      user.activities.last.key.should eq('user.create')

      response.should redirect_to(login_path)
    end
  end

  describe 'GET me' do
    let(:user){ Fabricate(:confirmed_user) }
    before{ @controller.send(:auto_login, user) }

    it 'should handle user profile changes' do
      get :me, :use_route => :coursewareable
      response.should render_template(:me)
    end
  end

  describe 'PUT update' do
    let(:user){ Fabricate(:confirmed_user) }
    before{ @controller.send(:auto_login, user) }

    it 'should handle user profile changes submission' do
      put :update, :use_route => :coursewareable, :id => user.id, :user => {
        :first_name => 'Stas', :last_name => 'Suscov'}

      user.reload
      user.first_name.should eq('Stas')
      user.last_name.should eq('Suscov')
      response.should redirect_to(me_users_path)
    end
  end

  it 'should handle invalid user activation' do
    get :activate, :use_route => :coursewareable, :id => Faker::HipsterIpsum.word

    response.should redirect_to(login_path)
  end

end
