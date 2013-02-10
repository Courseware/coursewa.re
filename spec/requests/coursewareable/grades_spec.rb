require 'spec_helper'

describe 'Grades' do
  let(:assignment) { Fabricate('coursewareable/assignment') }
  let(:classroom) { assignment.classroom }
  let(:lecture) { assignment.lecture }
  let(:receiver) do
    Fabricate('coursewareable/membership', :classroom => classroom).user
  end

  context 'when logged in' do
    let(:grade) { Fabricate('coursewareable/grade', :classroom => classroom,
                            :assignment => assignment)}
    let(:url_to_visit) do
      lecture_assignment_grades_url(
        lecture, assignment, :subdomain => classroom.slug)
    end

    before(:each) do
      sign_in_with(user.email)
      visit url_to_visit
    end

    context 'as owner/collaborator' do
      let(:user) { classroom.owner }

      it { page.should_not have_css('#grades ul.inline-list') }

      context 'when a grade exists' do
        before(:all) { grade }

        it do
          page.should have_css("#update_grade-#{grade.id}")
          page.should have_content(grade.receiver.name)
        end
      end

      context 'can create a new grade' do
        before(:all) { receiver }
        let(:attrs) { Fabricate.build('coursewareable/grade') }

        it do
          page.click_on('new_grade')
          page.fill_in('grade_mark', :with => attrs.mark)
          page.select('Percent', :from => 'grade_form')
          page.select(receiver.name, :from => 'grade_receiver_id')
          page.fill_in('grade_comment', :with => attrs.comment)
          page.click_on('submit_grade')

          new_grade = assignment.grades.first
          new_grade.mark.should eq(attrs.mark)
          new_grade.form.should eq('percent')
          new_grade.receiver.id.should eq(receiver.id)
          new_grade.comment.should eq(Sanitize.clean(attrs.comment))

          page.current_url.should eq(lecture_assignment_grades_url(
            lecture.slug, assignment.slug, :subdomain => classroom.slug))
        end
      end

      context 'can edit a grade' do
        before(:all) { grade }
        let(:attrs) { Fabricate.build('coursewareable/grade') }

        it do
          page.click_on("update_grade-#{grade.id}")
          page.fill_in('grade_mark', :with => attrs.mark)
          page.select('Percent', :from => 'grade_form')
          page.fill_in('grade_comment', :with => attrs.comment)
          page.click_on('update_grade')

          grade.reload.mark.should eq(attrs.mark)
          grade.form.should eq('percent')
          grade.comment.should eq(Sanitize.clean(attrs.comment))

          page.current_url.should eq(lecture_assignment_grades_url(
            lecture.slug, assignment.slug, :subdomain => classroom.slug))
        end
      end

    end
  end

end
