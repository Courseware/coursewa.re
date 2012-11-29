require 'spec_helper'

describe 'Passwords' do

  let(:user){ Fabricate('coursewareable/user') }

  it 'should handle password recovery' do
    visit new_password_url

    email_count = ActionMailer::Base.deliveries.count

    within('#recover') do
      fill_in 'email', :with => user.email
    end

    click_button 'submit_recover'

    page.should have_css('#notifications .alert-box')
  end

  it 'should handle password update' do
    token = Faker::HipsterIpsum.word.to_param
    ts = Time.now.in_time_zone + 1.day
    user.update_attribute :reset_password_token, token
    user.update_attribute :reset_password_token_expires_at, ts

    visit edit_password_url(token)

    within('#password_update') do
      fill_in 'password', :with => 'secret'
      fill_in 'password_confirmation', :with => 'secret'
    end

    click_button 'submit_password'

    page.should have_css('#notifications .alert-box')
  end

end
