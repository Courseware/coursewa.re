require 'spec_helper'

describe 'Responses' do
  let(:assignment) { Fabricate(:assignment_with_quiz) }
  let(:classroom) { assignment.classroom }
  let(:lecture) { assignment.lecture }
  let(:user) do
    Fabricate('coursewareable/membership', :classroom => classroom).user
  end

  context 'when logged in' do
    let(:url_to_visit) do
      lecture_assignment_url(lecture, assignment, :subdomain => classroom.slug)
    end

    before(:each) do
      user.activate!
      sign_in_with(user.email)
      visit url_to_visit
    end

    context 'as owner/collaborator' do
      let!(:response) { Fabricate('coursewareable/response',
        :classroom => classroom, :assignment => assignment, :user => user) }
      let(:user) { classroom.owner }


      it { page.should_not have_css('#assignment-add-response') }
    end

    context 'as a user' do
      let(:response) { Fabricate.build('coursewareable/response') }
      let(:text_answer) { Faker::Lorem.word }

      it { page.should have_css('#assignment-add-response') }

      it 'can add a response to be evaluated' do
        page.click_on('assignment-add-response')

        page.fill_in('response_content', :with => response.content)
        page.fill_in('txt-0-0', :with => text_answer )
        page.check('ckb-1-0')
        page.check('ckb-1-1')
        page.check('ckb-1-2')
        page.choose('rd-2-1')
        page.click_on('submit_response')

        page.current_url.should eq(lecture_assignment_response_url(
          lecture, assignment, assignment.responses.first,
          :subdomain => classroom.slug))

        page.should have_content('25.00%')
        page.should have_css(
          '#response .quiz-text .option.correct', :count => 0)
        page.should have_css('#response .quiz-text .option.wrong', :count => 1)

        page.should have_css(
          '#response .quiz-checkboxes .option.correct', :count => 2)
        page.should have_css(
          '#response .quiz-checkboxes .option.wrong', :count => 1)

        page.should have_css(
          '#response .quiz-radios .option.correct', :count => 0)
        page.should have_css(
          '#response .quiz-radios .option.wrong', :count => 1)

        page.should_not have_css('#response-delete')
      end

    end

  end
end
