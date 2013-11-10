require 'spec_helper'

describe 'Sessions' do

  let(:user){ Fabricate('coursewareable/user') }

  it 'should handle invalid login' do
    visit login_path

    email = Faker::Internet.email
    passwd = Faker::HipsterIpsum.word

    within('#login') do
      fill_in 'email', :with => email
      fill_in 'password', :with => passwd
    end

    click_button 'submit_login'

    page.should have_css('#notifications .alert-box.alert')
    page.should_not have_css('#dashboard-homes')
  end

  it 'should handle login for inactive accounts' do
    visit login_path

    within('#login') do
      fill_in 'email', :with => user.email
      fill_in 'password', :with => 'secret'
    end

    click_button 'submit_login'

    page.should have_css('#notifications .alert-box')
    page.should_not have_css('#dashboard-homes')
  end

  it 'should handle login for active accounts' do
    user.activate!

    visit login_path

    within('#login') do
      fill_in 'email', :with => user.email
      fill_in 'password', :with => 'secret'
    end

    click_button 'submit_login'

    page.should have_css('#login')
  end

  it 'should handle logout' do
    user.activate!
    sign_in_with(user.email)

    visit root_url
    page.should have_css('#dashboard-homes')
    visit logout_url
    visit root_url
    page.should_not have_css('#dashboard-homes')
  end
end
