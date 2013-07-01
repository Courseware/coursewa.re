require 'spec_helper'

describe 'Classrooms' do
  let(:classroom) { Fabricate('coursewareable/classroom') }

  it 'redirects if not logged in' do
    visit dashboard_classroom_url(:subdomain => classroom.slug)
    page.should have_css('#login')
  end

  it 'shows dashboard if logged in' do
    sign_in_with(classroom.owner.email)
    visit dashboard_classroom_url(:subdomain => classroom.slug)
    page.should have_content(classroom.title)
    page.should have_css('#dashboard-classrooms')
    page.should_not have_css('#activities .classroom-create')
  end

  it 'shows staff page if logged in' do
    sign_in_with(classroom.owner.email)
    visit staff_classroom_url(:subdomain => classroom.slug)
    page.should have_content(classroom.owner.name)
    page.should have_css('#classroom-staff')
  end

  it 'shows the edit screen if logged in' do
    sign_in_with(classroom.owner.email)
    visit edit_classroom_url(:subdomain => classroom.slug)
    page.should have_content(classroom.title)
  end

  it 'can post announcements if logged in' do
    sign_in_with(classroom.owner.email)
    visit dashboard_classroom_url(:subdomain => classroom.slug)

    ann_txt = Faker::Lorem.paragraph
    within('#announce') do
      fill_in 'announcement', :with => ann_txt
    end

    click_button 'submit_announcement'
    page.should have_css('#notifications .alert-box.success')
    page.should have_css('#activities .announcement-create')
    page.should have_content(ann_txt)
  end

  context 'menu' do
    let(:user) { Fabricate(:confirmed_user) }

    it 'can see menu if is member of classroom' do
      sign_in_with(classroom.owner.email)
      visit dashboard_classroom_url(:subdomain => classroom.slug)
      page.should have_css('#classroom-menu')
    end

    it 'can not see menu if want to create a classroom' do
      sign_in_with(user.email)
      visit start_classroom_path
      page.should_not have_css('#classroom-menu')
    end
  end
end
