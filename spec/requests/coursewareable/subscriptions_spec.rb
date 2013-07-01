require 'spec_helper'

describe 'Subscriptions' do
  context 'when not logged in' do
    it 'should not show plans' do
      visit new_subscription_path
      page.should_not have_css('#subscribe')
    end
  end

  context 'when logged in' do
    let(:user) { Fabricate(:confirmed_user) }

    it 'should show plans' do
      sign_in_with(user.email)
      visit new_subscription_url
      page.should have_css('#subscribe')
      page.should have_content('Free plan')
      page.should have_content('Micro plan')
      page.should have_content('Small plan')
      page.should have_content('Medium plan')
    end
  end
end
