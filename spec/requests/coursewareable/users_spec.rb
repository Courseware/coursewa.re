require 'spec_helper'

describe 'Users' do

  it 'should handle signups' do
    visit signup_path

    email = Faker::Internet.email
    passwd = Faker::Product.letters(8)
    emails_count = ActionMailer::Base.deliveries.count

    within('#new_user') do
      fill_in 'user_email', :with => email
      fill_in 'user_password', :with => passwd
      fill_in 'user_password_confirmation', :with => passwd
    end

    click_button 'submit_signup'

    page.should have_css('#notifications .alert-box')

    user = Coursewareable::User.find_by_email(email)
    user.should_not be_nil
    user.activation_state.should eq('pending')
    ActionMailer::Base.deliveries.count.should be > emails_count
  end

  it 'should handle invalid signups' do
    visit signup_path

    users_count = Coursewareable::User.count
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
    Coursewareable::User.count.should eq(users_count)
  end

  it 'should handle profile updates' do
    user = Fabricate(:confirmed_user)
    sign_in_with(user.email)

    visit me_users_url

    within('.edit_user') do
      fill_in 'user[first_name]', :with => 'Stas'
      fill_in 'user[last_name]', :with => 'Suscov'
    end

    click_button 'submit_profile'

    page.should have_css('#notifications .alert-box')

    user.reload
    user.first_name.should eq('Stas')
    user.last_name.should eq('Suscov')
  end

  it 'handles invitations' do
    user = Fabricate(:confirmed_user)
    sign_in_with(user.email)

    emails_count = ActionMailer::Base.deliveries.count
    visit invite_users_url

    within('#new_invitation') do
      fill_in 'email', :with => Faker::Internet.email
      fill_in 'message', :with => Faker::Lorem.paragraph
    end

    click_button 'submit_invitation'

    page.should have_css('#notifications .alert-box.success')
    ActionMailer::Base.deliveries.count.should eq(emails_count + 1)
  end

  it 'should be able to manage notification settings' do
    classroom = Fabricate('coursewareable/classroom')
    sign_in_with(classroom.owner.email)

    visit notifications_users_url

    page.should have_content(classroom.title)
    page.should have_checked_field(
      'user_associations_attributes_0_send_grades')
    page.should have_checked_field(
      'user_associations_attributes_0_send_generic')
    page.should have_checked_field(
      'user_associations_attributes_0_send_announcements')

    page.uncheck('user_associations_attributes_0_send_grades')
    click_button('update_notifications')

    page.should have_unchecked_field(
      'user_associations_attributes_0_send_grades')
    page.should have_checked_field(
      'user_associations_attributes_0_send_generic')
    page.should have_checked_field(
      'user_associations_attributes_0_send_announcements')
    page.should have_css('#notifications .alert-box.success')
  end

  it 'should be able to send delete account request' do
    user = Fabricate(:confirmed_user)
    sign_in_with(user.email)

    visit request_deletion_users_url

    page.should have_content('Delete your account')
    page.should have_field('message')
    page.should have_button('Send request')

    within('#delete') do
      fill_in 'message', :with => Faker::Lorem.paragraph
    end

    click_button 'delete_button'

    user.reload.id.should eq(user.id)
    page.should have_css('#notifications .alert-box.success')
  end
end
