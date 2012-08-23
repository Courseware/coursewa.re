require 'spec_helper'

describe PasswordsController do

  let(:user){ Fabricate(:user) }

  it 'should handle invalid user recovery' do
    visit new_password_path

    within('#recover') do
      fill_in 'email', :with => Faker::Internet.email
    end

    click_button 'submit_recover'

    page.should have_css('#notifications .alert-box.alert')
  end

  it 'should handle password recovery' do
    visit new_password_path

    email_count = ActionMailer::Base.deliveries.count

    within('#recover') do
      fill_in 'email', :with => user.email
    end

    click_button 'submit_recover'

    page.should have_css('#notifications .alert-box')

    # Call ActiveRecord since token was not cached yet
    uncached_user = User.find(user.id)
    uncached_user.reset_password_token.should_not be_nil

    ActionMailer::Base.deliveries.count.should be > email_count
  end

  it 'should handle password recovery' do
    visit new_password_path

    email_count = ActionMailer::Base.deliveries.count

    within('#recover') do
      fill_in 'email', :with => user.email
    end

    click_button 'submit_recover'

    page.should have_css('#notifications .alert-box')

    uncached_user = user.reload
    uncached_user.reset_password_token.should_not be_nil

    ActionMailer::Base.deliveries.count.should be > email_count
  end


  it 'should handle invalid password recovery access' do
    token = Faker::HipsterIpsum.word

    get :edit, :id => token

    response.should be_redirect
  end

  it 'should handle password recovery' do
    token = Faker::HipsterIpsum.word.to_param
    user.update_attribute :reset_password_token, token
    user.update_attribute :reset_password_token_expires_at, Date.tomorrow

    visit edit_password_path(token)

    within('#password_update') do
      fill_in 'password', :with => 'secret'
      fill_in 'password_confirmation', :with => 'secret'
    end

    click_button 'submit_password'

    page.should have_css('#notifications .alert-box')

    user.reload.reset_password_token.should be_nil
  end

  it 'should handle wrong passwords situation on recovery page' do
    token = Faker::HipsterIpsum.word.to_param
    user.update_attribute :reset_password_token, token
    user.update_attribute :reset_password_token_expires_at, Date.tomorrow

    visit edit_password_path(token)

    within('#password_update') do
      fill_in 'password', :with => 'secret'
      fill_in 'password_confirmation', :with => 'another_secret'
    end

    click_button 'submit_password'

    page.should have_css('#notifications .alert-box')

    user.reload.reset_password_token.should_not be_nil
  end

end
