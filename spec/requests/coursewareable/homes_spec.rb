require 'spec_helper'

describe 'Home' do
  context 'when not logged in' do
    it 'should show dasboard' do
      visit root_url
      page.should_not have_css('#new-sessions')
    end
  end

  context 'when logged in' do
    let(:user){ Fabricate('coursewareable/user') }

    it 'should show dasboard' do
      visit activate_user_url(user.activation_token)
      sign_in_with(user.email)
      visit root_url
      page.should have_css('#dashboard-homes')
      page.should have_css('#activities .coursewareable_user-create')
      page.should have_xpath("//a[@href='#{start_classroom_path}']")
    end

    it 'should be able to create a classroom' do
      user.activate!
      sign_in_with(user.email)

      visit start_classroom_url

      title = Faker::Education.school[0..31]
      description = Faker::HTMLIpsum.fancy_string

      within('#new_classroom') do
        fill_in 'classroom_title', :with => title
        fill_in 'classroom_description', :with => description
      end

      click_button 'submit_new_classroom'

      page.should have_content(title)
    end
  end

  context 'when classrooms limits reached' do
    let(:user){ Fabricate('coursewareable/classroom').owner.reload }

    it 'should not show classrooms creation link' do
      sign_in_with(user.email)
      visit root_url
      page.should_not have_xpath("//a[@href='#{start_classroom_path}']")
    end
  end

end
