require 'spec_helper'

describe 'Assignments' do
  let(:lecture) { Fabricate('coursewareable/lecture') }
  let(:classroom) { lecture.classroom }

  context 'when logged in' do
    it 'should not show assignments if none was added' do
      sign_in_with(classroom.owner.email)
      visit lecture_url(lecture, :subdomain => classroom.slug)
      page.should_not have_css('#assignments')
    end

    it 'should create assignment' do
      sign_in_with(classroom.owner.email)
      visit new_lecture_assignment_url(lecture, :subdomain => classroom.slug)

      assignment = Fabricate.build('coursewareable/assignment',
        :lecture => lecture, :classroom => classroom, :user => classroom.owner)

      page.fill_in('assignment_title', :with => assignment.title)
      page.fill_in('assignment_content', :with => assignment.content)
      page.click_on('submit_assignment')

      page.source.should match(assignment.title)
      page.should have_css('#notifications .success')
      page.should have_css('#assignment_title')
    end
  end

  describe 'when assignment exists' do
    let!(:assignment) {
      Fabricate('coursewareable/assignment', :lecture => lecture,
        :user => classroom.owner, :classroom => classroom)
    }

    context 'and logged in' do

      it 'should show lecture if logged in' do
        sign_in_with(classroom.owner.email)
        visit lecture_assignment_url(
          lecture, assignment, :subdomain => classroom.slug)

        page.should have_content(assignment.title)
        page.source.should match(assignment.content)
        page.should have_css('#assignment')
        page.should have_css('#assignment .assignment-update')
      end

      it 'should update lecture' do
        sign_in_with(classroom.owner.email)
        visit edit_lecture_assignment_url(
          lecture, assignment, :subdomain => classroom.slug)

        assignment_params = Fabricate.build('coursewareable/assignment',
          :classroom => classroom, :user => classroom.owner,
          :lecture => lecture)

        page.fill_in('assignment_title', :with => assignment_params.title)
        page.fill_in('assignment_content', :with => assignment_params.content)
        page.click_on('submit_assignment')

        page.source.should match(assignment_params.title)
        page.should have_css('#notifications .success')
      end

    end
  end

end
