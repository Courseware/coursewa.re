require 'spec_helper'

describe Coursewareable::PasswordsController do

  let(:user) { Fabricate(:confirmed_user) }
  let(:create_token) {
    token = Faker::HipsterIpsum.word.parameterize
    ts = Time.now.in_time_zone + 1.day
    user.update_attribute :reset_password_token, token
    user.update_attribute :reset_password_token_expires_at, ts
    token
  }

  describe 'GET new' do
    before do
      @controller.send(:auto_login, user)
      get(:new, :use_route => :coursewareable)
    end

    it{ should redirect_to(root_path) }
  end

  describe 'POST create' do
    before do
      @controller.send(:auto_login, user)
      @emails_count = ActionMailer::Base.deliveries.count
      post(:create, :use_route => :coursewareable, :email => user.email)
    end

    context 'with a wrong email' do
      let(:user) { Fabricate.build('coursewareable/user') }

      it { should redirect_to(root_path) }
    end

    it { should redirect_to(root_path) }
    it { @emails_count.should eq(ActionMailer::Base.deliveries.count) }
  end

  describe 'GET edit' do
    before do
      @controller.send(:auto_login, user)
      get(:edit, :use_route => :coursewareable, :id => create_token)
    end

    it { should redirect_to(root_path) }

    context 'with invalid token' do
      let(:create_token) { 'wrong' }

      it { should redirect_to(root_path) }
    end
  end

  describe 'POST update' do
    let(:password) { 'new_secret' }
    let(:password_confirmation) { 'new_secret' }

    before do
      @old_pass = user.crypted_password
      @controller.send(:auto_login, user)
      post( :update, :use_route => :coursewareable,
           :id => user.id, :token => create_token,
           :password => password,
           :password_confirmation => password_confirmation)
    end

    context 'with invalid token' do
      let(:create_token) { 'wrong' }

      it { should redirect_to(root_path) }
    end

    it 'does not update password' do
      user.reload.reset_password_token.should_not be_nil
      user.crypted_password.should eq(@old_pass)
      response.should redirect_to(root_path)
    end

    context 'with valid token and different passwords' do
      let(:password_confirmation) { 'wrong_' + password }

      it { should redirect_to(root_path) }
    end
  end

end
