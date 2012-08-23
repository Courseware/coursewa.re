require 'spec_helper'

describe UsersController do

  it 'should handle signups' do
    visit signup_path

    email = Faker::Internet.email
    passwd = Faker::HipsterIpsum.word
    emails_count = ActionMailer::Base.deliveries.count

    within('#new_user') do
      fill_in 'user_email', :with => email
      fill_in 'user_password', :with => passwd
      fill_in 'user_password_confirmation', :with => passwd
    end

    click_button 'submit_signup'

    page.should have_css('#notifications .alert-box')

    ActionMailer::Base.deliveries.count.should be > emails_count

    user = User.find_by_email(email)

    user.should_not be_nil
    user.activation_state.should eq('pending')
  end

  it 'should handle invalid signups' do
    visit signup_path

    users_count = User.count
    emails_count = ActionMailer::Base.deliveries.count

    within('#new_user') do
      fill_in 'user_email', :with => ''
      fill_in 'user_password', :with => ''
      fill_in 'user_password_confirmation', :with => ''
    end

    click_button 'submit_signup'

    page.should have_css('#notifications .alert-box')
    page.should have_css('#new_user .error.form-field')

    ActionMailer::Base.deliveries.count.should eq(emails_count)
    User.count.should eq(users_count)
  end

  it 'should handle user activation' do
    user = Fabricate(:user)
    user.activation_state.should eq('pending')

    visit activate_user_path(user.activation_token)

    page.should have_css('#notifications .alert-box.success')

    # Ignore any caches
    user.reload.activation_state.should eq('active')
    user.activities.last.key.should eq('activity.user.create')
  end

  it 'should handle invalid user activation' do
    get :activate, :id => Faker::HipsterIpsum.word

    response.should be_redirect
  end

end
