require 'spec_helper'

describe 'Classrooms' do
  let(:classroom) { Fabricate(:classroom) }

  it 'it should redirect if not logged in' do
    visit dashboard_classrooms_url(:subdomain => classroom.slug)
    page.should have_css('#login')
  end

  it 'it should show dashboard if logged in' do
    sign_in_with(classroom.owner.email)
    visit dashboard_classrooms_url(:subdomain => classroom.slug)
    page.should have_content(classroom.title)
  end

end
