require 'spec_helper'

describe 'Memberships' do
  let(:classroom) { Fabricate('coursewareable/classroom') }

  it 'shows members list if logged in' do
    sign_in_with(classroom.owner.email)
    visit memberships_url(:subdomain => classroom.slug)
    page.should have_css('#members-list')
  end

  context 'with some members' do
    let(:new_member) { Fabricate(:confirmed_user) }
    before { classroom.members << new_member }

    it 'can remove one' do
      sign_in_with(classroom.owner.email)
      visit memberships_url(:subdomain => classroom.slug)

      click_on "remove-membership-#{classroom.memberships.last.id}"
      page.should_not have_css(
        "#remove-membership-#{classroom.memberships.last.id}")
    end
  end

end
