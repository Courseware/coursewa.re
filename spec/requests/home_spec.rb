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
      user.activate!
      sign_in_with(user.email)
      visit root_url
      page.should have_css('#dashboard-home')
    end
  end

end
