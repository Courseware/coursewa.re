require 'spec_helper'

describe Coursewareable::PasswordsController do

  let(:user) { Fabricate('coursewareable/user') }
  let(:create_token) {
    token = Faker::HipsterIpsum.word.parameterize
    ts = Time.now.in_time_zone + 1.day
    user.update_attribute :reset_password_token, token
    user.update_attribute :reset_password_token_expires_at, ts
    token
  }

  describe 'GET new' do
    before { get(:new, :use_route => :coursewareable) }

    it{ should render_template(:new) }
  end

  describe 'POST create' do
    let(:user) { Fabricate('coursewareable/user') }

    before(:each) do
      post(:create, :use_route => :coursewareable, :email => user.email)
      @last_email = ActionMailer::Base.deliveries.last
    end

    context 'with a wrong email' do
      let(:user) { Fabricate.build('coursewareable/user') }

      it { should redirect_to(new_password_path) }
    end

    subject { @last_email }

    it { should(have_body_text(edit_password_path(
      user.reload.reset_password_token))) }
  end

  describe 'GET edit' do
    before { get(:edit, :use_route => :coursewareable, :id => create_token) }

    it{ should render_template(:edit) }

    context 'with invalid token' do
      let(:create_token) { 'wrong' }

      it{ should redirect_to('/404') }
    end
  end

  describe 'POST update' do
    let(:password) { 'new_secret' }
    let(:password_confirmation) { 'new_secret' }

    before do
      @old_pass = user.crypted_password
      post( :update, :use_route => :coursewareable,
           :id => user.id, :token => create_token,
           :password => password,
           :password_confirmation => password_confirmation)
    end

    context 'with invalid token' do
      let(:create_token) { 'wrong' }

      it{ should redirect_to(login_path) }
    end

    it 'updates password' do
      user.reload.reset_password_token.should be_nil
      user.crypted_password.should_not eq(@old_pass)
      response.should redirect_to(login_path)
    end

    context 'with valid token and different passwords' do
      let(:password_confirmation) { 'wrong_' + password }

      it 'fails to update the password' do
        user.reload.reset_password_token.should_not be_nil
        user.crypted_password.should eq(@old_pass)
        response.should redirect_to(edit_password_path(create_token))
      end
    end
  end

end
