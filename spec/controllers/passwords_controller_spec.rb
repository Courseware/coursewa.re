require 'spec_helper'

describe PasswordsController do

  let(:user){ Fabricate(:user) }
  let(:create_token){
    token = Faker::HipsterIpsum.word.parameterize
    user.update_attribute :reset_password_token, token
    user.update_attribute :reset_password_token_expires_at, Date.tomorrow
    token
  }

  describe 'GET new' do
    subject{ get :new }
    it{ should render_template(:new) }
  end

  describe 'POST create' do
    context 'with wrong email' do
      subject{ post :create, :email => Faker::Internet.email }
      it{ should redirect_to(new_password_path) }
    end

    context 'with a correct email' do
      it 'should trigger password recovery' do
        email_count = ActionMailer::Base.deliveries.count
        user.reset_password_token.should be_nil

        post :create, :email => user.email

        user.reload.reset_password_token.should_not be_nil
        ActionMailer::Base.deliveries.count.should be > email_count
      end
    end
  end

  describe 'GET edit' do
    context 'with invalid token' do
      subject{ get :edit, :id => 'wrong' }
      it{ should redirect_to('/404')}
    end

    context 'with valid token' do
      subject{ get :edit, :id => create_token }
      it{ should render_template(:edit) }
    end
  end

  describe 'POST update' do
    context 'with invalid token' do
      subject{ put :update, :id => user.id, :token => 'wrong' }
      it{ should redirect_to(login_path) }
    end

    context 'with valid token' do
      it 'should update password' do
        old_pass = user.crypted_password
        post( :update, :id => user.id, :token => create_token,
              :password => 'new_secret',
              :password_confirmation => 'new_secret')

        user.reload.reset_password_token.should be_nil
        user.crypted_password.should_not eq(old_pass)
        response.should redirect_to(root_path)
      end
    end

    context 'with valid token and different passwords' do
      it 'should update password' do
        old_pass = user.crypted_password
        token = create_token
        post( :update, :id => user.id, :token => token,
              :password => 'wrong_new_secret',
              :password_confirmation => 'new_secret')

        user.reload.reset_password_token.should_not be_nil
        user.crypted_password.should eq(old_pass)
        response.should redirect_to(edit_password_path(token))
      end
    end
  end

end
