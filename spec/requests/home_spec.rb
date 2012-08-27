require 'spec_helper'

describe 'Home' do
  context 'when not logged in' do
    it 'should show dasboard' do
      visit root_url
      page.should have_css('#new-sessions')
    end
  end

  context 'when logged in' do
    let(:user){ Fabricate(:user) }

    it 'should show dasboard' do
      visit activate_user_url(user.activation_token)
      sign_in_with(user.email)
      visit root_url
      page.should have_css('#dashboard-home')
      page.should have_css('#activities .user-create')
      page.should have_xpath("//a[@href='#{start_classroom_path}']")
    end
  end

  context 'when classrooms limits reached' do
    let(:user){ Fabricate(:classroom).owner.reload }

    it 'should not show classrooms creation link' do
      sign_in_with(user.email)
      visit root_url
      page.should_not have_xpath("//a[@href='#{start_classroom_path}']")
    end
  end

end
