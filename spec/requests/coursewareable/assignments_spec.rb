require 'spec_helper'

describe 'Assignments' do
  let(:lecture) { Fabricate('coursewareable/lecture') }
  let(:classroom) { lecture.classroom }

  context 'when logged in' do
    let(:url_to_visit) { lecture_url(lecture, :subdomain => classroom.slug) }

    before do
      sign_in_with(classroom.owner.email)
      visit url_to_visit
    end

    it 'should not show assignments if none was added' do
      page.should_not have_css('#assignments')
    end

    context 'on new assignment page' do
      let(:url_to_visit) do
        new_lecture_assignment_url(lecture, :subdomain => classroom.slug)
      end
      let(:assignment) { Fabricate.build('coursewareable/assignment') }

      it 'should create assignment' do
        page.fill_in('assignment_title', :with => assignment.title)
        page.fill_in('assignment_content', :with => assignment.content)
        page.click_on('submit_assignment')

        page.source.should match(assignment.title)
        page.should have_css('#notifications .success')
        page.should have_css('#assignment')
      end
    end
  end

  describe 'when assignment exists' do
    let!(:assignment) {
      Fabricate('coursewareable/assignment', :lecture => lecture,
        :user => classroom.owner, :classroom => classroom)
    }

    context 'and logged in' do
      before do
        sign_in_with(classroom.owner.email)
        visit lecture_assignment_url(
          lecture, assignment, :subdomain => classroom.slug)
      end

      it 'shows assignment if logged in' do
        page.should have_content(assignment.title)
        page.source.should match(assignment.content)
        page.should have_css('#assignment')
        page.should have_css('#assignment-update')
      end

      it 'updates assignment' do
        click_on('assignment-update')
        assignment_params = Fabricate.build('coursewareable/assignment')

        page.fill_in('assignment_title', :with => assignment_params.title)
        page.fill_in('assignment_content', :with => assignment_params.content)
        page.click_on('submit_assignment')

        page.source.should match(assignment_params.title)
        page.should have_css('#notifications .success')
      end

      context 'assignment has a quiz' do
        let(:quiz) { Fabricate.build(:assignment_with_quiz).quiz }
        before(:all) { assignment.update_attribute(:quiz, quiz) }

        it do
          page.should have_css('#assignment .quiz-text', :count => 1)
          page.should have_css('#assignment .quiz-radios', :count => 1)
          page.should have_css('#assignment .quiz-checkboxes', :count => 1)

          page.should have_css( '.quiz-text textarea[disabled]', 1)

          page.should have_css(
            '.quiz-checkboxes input[type="checkbox"][checked][disabled]', 2)
          page.should have_css(
            '.quiz-checkboxes input[type="checkbox"][disabled]', 3)

          page.should have_css(
            '.quiz-radios input[type="radio"][checked][disabled]', 1)
          page.should have_css('.quiz-radios input[type="radio"][disabled]', 3)
        end
      end

    end
  end

end
