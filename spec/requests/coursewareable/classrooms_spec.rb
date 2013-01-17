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

  it 'shows the edit screen if logged in' do
    sign_in_with(classroom.owner.email)
    visit edit_classroom_url(:subdomain => classroom.slug)
    page.should have_content(classroom.title)
    page.should have_css('#members-list')
    page.should_not have_css('#collaborators-list')
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

  context 'with some members' do
    let(:new_member) { Fabricate(:confirmed_user) }
    before { classroom.members << new_member }

    it 'removes a member if logged in' do
      sign_in_with(classroom.owner.email)
      visit edit_classroom_url(:subdomain => classroom.slug)
      click_on "remove-membership-#{classroom.memberships.last.id}"
      page.should_not have_css(
        "#remove-membership-#{classroom.memberships.last.id}")
    end
  end

  context 'with some collaborators' do
    let(:new_collab) { Fabricate(:confirmed_user) }
    before { classroom.collaborators << new_collab }

    it 'removes a collaborator if logged in' do
      sign_in_with(classroom.owner.email)
      visit edit_classroom_url(:subdomain => classroom.slug)

      classroom.collaborations.reload
      click_on "remove-collaboration-#{classroom.collaborations.last.id}"
      page.should_not have_css(
        "#remove-collaboration-#{classroom.collaborations.last.id}")
    end
  end

end
