require 'spec_helper'

describe UsersController do

  describe 'GET new' do
    context 'when user is not logged in' do
      subject{ get :new }
      it { should render_template(:new) }
    end

    context 'when user is logged in' do
      subject{ get :new }
      before{ @controller.send(:auto_login, Fabricate(:user)) }
      it { should redirect_to(root_path) }
    end
  end

  describe 'POST create' do
    context 'missing params' do
      it 'should not create a new user' do
        users_count = User.count
        emails_count = ActionMailer::Base.deliveries.count

        post :create

        response.should render_template(:new)
        ActionMailer::Base.deliveries.count.should eq(emails_count)
        User.count.should eq(users_count)
      end
    end

    context 'when user is logged in' do
      it 'should not create a new user' do
      @controller.send(:auto_login, Fabricate(:user))

      users_count = User.count
      emails_count = ActionMailer::Base.deliveries.count

      email = Faker::Internet.email
      passwd = Faker::Product.letters(8)

      post :create, :user => {
        :email => email,
        :password => passwd,
        :password_confirmation => passwd
      }

      ActionMailer::Base.deliveries.count.should eq(emails_count)
      User.count.should eq(users_count)
      response.should redirect_to(login_path)
      end
    end

    it 'should create a new user' do
      users_count = User.count
      emails_count = ActionMailer::Base.deliveries.count

      email = Faker::Internet.email
      passwd = Faker::Product.letters(8)

      post :create, :user => {
        :email => email,
        :password => passwd,
        :password_confirmation => passwd
      }

      ActionMailer::Base.deliveries.count.should_not eq(emails_count)
      User.count.should_not eq(users_count)
      response.should redirect_to(root_path)
    end
  end

  describe 'GET activate' do
    it 'should handle user activation' do
      user = Fabricate(:user)
      user.activation_state.should eq('pending')

      get :activate, :id => user.activation_token

      # Ignore any caches
      user.reload.activation_state.should eq('active')
      user.activities.last.key.should eq('user.create')

      response.should redirect_to(login_path)
    end
  end

  it 'should handle invalid user activation' do
    get :activate, :id => Faker::HipsterIpsum.word

    response.should redirect_to(login_path)
  end

end
