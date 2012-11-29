require 'spec_helper'

describe 'Syllabuses' do
  let(:classroom) { Fabricate('coursewareable/classroom') }

  it 'it should redirect if not logged in' do
    visit syllabus_url(:subdomain => classroom.slug)
    page.should have_css('#login')
  end

  it 'it should redirect without update if not logged in' do
    visit edit_syllabus_url(:subdomain => classroom.slug)
    page.should have_css('#login')
  end

  it 'it should show syllabus missing if logged in' do
    sign_in_with(classroom.owner.email)
    visit syllabus_url(:subdomain => classroom.slug)
    page.should have_css('#syllabus')
    page.should have_css('#syllabus .syllabus-create')
  end

  it 'it should create syllabus if logged in' do
    sign_in_with(classroom.owner.email)
    visit edit_syllabus_url(:subdomain => classroom.slug)

    syllabus = Fabricate.build('coursewareable/syllabus',
      :classroom => classroom, :user => classroom.owner)

    page.fill_in('syllabus_title', :with => syllabus.title)
    page.fill_in('syllabus_intro', :with => syllabus.intro)
    page.fill_in('syllabus_content', :with => syllabus.content)
    page.click_on('submit_syllabus')

    page.should have_content(syllabus.title)
    page.should have_css('#notifications .success')
  end

  describe 'when syllabus exists' do
    before {
      @syllabus = Fabricate('coursewareable/syllabus',
        :user => classroom.owner, :classroom => classroom)
    }

    it 'it should show syllabus if logged in' do
      sign_in_with(classroom.owner.email)
      visit syllabus_url(:subdomain => classroom.slug)

      page.should have_content(@syllabus.title)
      page.source.should match(@syllabus.content)
      page.should have_content(@syllabus.intro)
      page.should have_css('#syllabus')
      page.should_not have_css('#syllabus .syllabus-create')
    end

    it 'it should show update syllabus if logged in' do
      sign_in_with(classroom.owner.email)
      visit edit_syllabus_url(:subdomain => classroom.slug)

      page.should have_css('#syllabus_title')
      page.should have_css('#syllabus_intro')
      page.should have_css('#syllabus_content')
      page.should have_css('#submit_syllabus')
    end

    it 'it should update syllabus if logged in' do
      sign_in_with(classroom.owner.email)
      visit edit_syllabus_url(:subdomain => classroom.slug)

      syllabus = Fabricate.build('coursewareable/syllabus',
        :classroom => classroom, :user => classroom.owner)

      page.fill_in('syllabus_title', :with => syllabus.title)
      page.fill_in('syllabus_intro', :with => syllabus.intro)
      page.fill_in('syllabus_content', :with => syllabus.content)
      page.click_on('submit_syllabus')

      page.should have_content(syllabus.title)
      page.should have_css('#notifications .success')
    end
  end

end
