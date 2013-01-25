require 'spec_helper'

describe 'Collaborations' do
  let(:classroom) { Fabricate('coursewareable/classroom') }

  it 'shows collaborators list if logged in' do
    sign_in_with(classroom.owner.email)
    visit collaborations_url(:subdomain => classroom.slug)
    page.should_not have_css('#collaborators-list')
  end

  context 'with some collaborators' do
    let(:new_collab) { Fabricate(:confirmed_user) }
    before do
      classroom.collaborators << new_collab
      classroom.collaborations.reload
    end

    it 'can remove one' do
      sign_in_with(classroom.owner.email)
      visit collaborations_url(:subdomain => classroom.slug)

      click_on "remove-collaboration-#{classroom.collaborations.last.id}"
      page.should_not have_css(
        "#remove-collaboration-#{classroom.collaborations.last.id}")
    end
  end
end
