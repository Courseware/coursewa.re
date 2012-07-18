require 'spec_helper'

describe UsersController, :type => :request do
  render_views

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

    response.should be_success
    page.should have_css('#notifications .alert-box')

    ActionMailer::Base.deliveries.count.should be > emails_count
    ActionMailer::Base.deliveries.last.to.should include(email)

    user = User.find_by_email(email)
    user.should_not be_nil
    user.activation_state.should eq('pending')
  end

end
