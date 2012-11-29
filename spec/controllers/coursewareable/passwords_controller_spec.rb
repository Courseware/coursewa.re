require 'spec_helper'

describe Coursewareable::PasswordsController do

  let(:user){ Fabricate('coursewareable/user') }
  let(:create_token){
    token = Faker::HipsterIpsum.word.parameterize
    ts = Time.now.in_time_zone + 1.day
    user.update_attribute :reset_password_token, token
    user.update_attribute :reset_password_token_expires_at, ts
    token
  }

  describe 'GET new' do
    subject{ get :new, :use_route => :coursewareable }
    it{ should render_template(:new) }
  end

  describe 'POST create' do
    context 'with wrong email' do
      subject{ post :create, :use_route => :coursewareable,
               :email => Faker::Internet.email }
      it{ should redirect_to(new_password_path) }
    end

    context 'with a correct email' do
      it 'should trigger password recovery' do
        email_count = ActionMailer::Base.deliveries.count
        user.reset_password_token.should be_nil

        post :create, :use_route => :coursewareable, :email => user.email

        user.reload.reset_password_token.should_not be_nil
        ActionMailer::Base.deliveries.count.should be > email_count
      end
    end
  end

  describe 'GET edit' do
    context 'with invalid token' do
      subject{ get :edit, :use_route => :coursewareable, :id => 'wrong' }
      it{ should redirect_to('/404')}
    end

    context 'with valid token' do
      subject{ get :edit, :use_route => :coursewareable, :id => create_token }
      it{ should render_template(:edit) }
    end
  end

  describe 'POST update' do
    context 'with invalid token' do
      subject{ put :update, :use_route => :coursewareable,
               :id => user.id, :token => 'wrong' }
      it{ should redirect_to(login_path) }
    end

    context 'with valid token' do
      it 'should update password' do
        old_pass = user.crypted_password
        post( :update, :use_route => :coursewareable,
              :id => user.id, :token => create_token,
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
        post( :update, :use_route => :coursewareable,
              :id => user.id, :token => token,
              :password => 'wrong_new_secret',
              :password_confirmation => 'new_secret')

        user.reload.reset_password_token.should_not be_nil
        user.crypted_password.should eq(old_pass)
        response.should redirect_to(edit_password_path(token))
      end
    end
  end

end
