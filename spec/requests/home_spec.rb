require 'spec_helper'

describe 'Home' do
  let(:user){ Fabricate(:user) }

  context 'when not logged in' do
    it 'should show dasboard' do
      visit root_url
      page.should have_css('#new-sessions')
    end
  end

  context 'when logged in' do
    it 'should show dasboard' do
      visit activate_user_url(user.activation_token)
      sign_in_with(user.email)
      visit root_url
      page.should have_css('#dashboard-home')
      page.should have_css('#activities .user-create')
    end
  end

end
