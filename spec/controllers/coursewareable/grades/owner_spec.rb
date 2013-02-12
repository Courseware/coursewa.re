require 'spec_helper'

describe Coursewareable::GradesController do
  let(:assignment) { Fabricate('coursewareable/assignment') }
  let(:lecture) { assignment.lecture }
  let(:classroom) { assignment.classroom }

  describe 'GET new' do
    context 'being logged in as owner' do
      before do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "#{classroom.slug}.#{@request.host}"
        get(:new, :lecture_id => lecture.slug,
            :assignment_id => assignment.slug, :use_route => :coursewareable)
      end

      it { should render_template(:new) }
    end
  end

  describe 'POST create' do
    let(:receiver) do
      Fabricate('coursewareable/membership', :classroom => classroom).user
    end
    let(:grade) do
      Fabricate.build('coursewareable/grade')
    end

    context 'being logged in as owner' do
      before do
        GradesMailer.stub(:delay).and_return(GradesMailer)
        GradesMailer.should_receive(:new_grade_email)
        @controller.send(:auto_login, classroom.owner)
        @request.host = "#{classroom.slug}.#{@request.host}"
        post(:create, :lecture_id => lecture.slug,:use_route => :coursewareable,
             :assignment_id => assignment.slug, :grade => {
               :receiver_id => receiver.id, :form => grade.form,
               :mark => grade.mark, :comment => grade.comment
        })
      end

      it { should redirect_to(lecture_assignment_grades_path(
        lecture.slug, assignment.slug)) }
    end
  end

  describe 'GET edit' do
    let(:grade) do
      Fabricate('coursewareable/grade',
                :classroom => classroom, :assignment => assignment)
    end

    context 'being logged in as owner' do
      before do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "#{classroom.slug}.#{@request.host}"
        get(:edit, :lecture_id => lecture.slug, :id => grade.id,
            :assignment_id => assignment.slug,
            :use_route => :coursewareable)
      end

      it { should render_template(:edit) }
    end
  end

  describe 'PUT update' do
    let(:grade) do
      Fabricate('coursewareable/grade',
                :classroom => classroom, :assignment => assignment)
    end

    context 'being logged in as owner' do
      before do
        GradesMailer.stub(:delay).and_return(GradesMailer)
        GradesMailer.should_receive(:update_grade_email)
        @controller.send(:auto_login, classroom.owner)
        @request.host = "#{classroom.slug}.#{@request.host}"
        put(:update, :lecture_id => lecture.slug, :id => grade.id,
            :assignment_id => assignment.slug, :use_route => :coursewareable,
            :grade => { :receiver_id => classroom.owner.id, :form => 'percent',
              :mark => 70 }
           )
        grade.reload
      end

      it do
        grade.receiver.id.should_not eq(classroom.owner.id)
        grade.mark.should eq(70)
        grade.form.should eq('percent')
        should redirect_to(lecture_assignment_grades_path(
          lecture.slug, assignment.slug))
      end
    end
  end

  describe 'DELETE destroy' do
    let(:grade) do
      Fabricate('coursewareable/grade',
                :classroom => classroom, :assignment => assignment)
    end

    context 'being logged in as owner' do
      before do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "#{classroom.slug}.#{@request.host}"
        delete(:destroy, :lecture_id => lecture.slug, :id => grade.id,
            :assignment_id => assignment.slug, :use_route => :coursewareable)
      end

      it do
        assignment.grades.should be_empty
        should redirect_to(lecture_assignment_grades_path(
          lecture.slug, assignment.slug))
      end
    end
  end

  describe 'GET index' do
    let(:grade) do
      Fabricate('coursewareable/grade',
                :classroom => classroom, :assignment => assignment)
    end

    context 'being logged in as owner' do
      before do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "#{classroom.slug}.#{@request.host}"
        get(:index, :lecture_id => lecture.slug,
            :assignment_id => assignment.slug, :use_route => :coursewareable)
      end

      it { should render_template(:index) }
    end
  end

end
