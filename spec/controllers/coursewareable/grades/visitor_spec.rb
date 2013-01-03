require 'spec_helper'

describe Coursewareable::GradesController do
  let(:assignment) { Fabricate('coursewareable/assignment') }
  let(:lecture) { assignment.lecture }
  let(:classroom) { assignment.classroom }

  describe 'GET new' do
    context 'not being logged in' do
      before do
        @request.host = "#{classroom.slug}.#{@request.host}"
        get(:new, :lecture_id => lecture.slug,
            :assignment_id => assignment.slug, :use_route => :coursewareable)
      end

      it { should redirect_to(login_path) }
    end
  end

  describe 'POST create' do
    let(:receiver) do
      Fabricate('coursewareable/membership', :classroom => classroom).user
    end
    let(:grade) do
      Fabricate.build('coursewareable/grade')
    end

    context 'not being logged in' do
      before do
        @request.host = "#{classroom.slug}.#{@request.host}"
        post(:create, :lecture_id => lecture.slug,:use_route => :coursewareable,
             :assignment_id => assignment.slug, :grade => {
               :receiver_id => receiver.id, :form => grade.form,
               :mark => grade.mark, :comment => grade.comment
        })
      end

      it { should redirect_to(login_path) }
    end
  end

  describe 'GET edit' do
    let(:grade) do
      Fabricate('coursewareable/grade',
                :classroom => classroom, :assignment => assignment)
    end

    context 'not being logged in' do
      before do
        @request.host = "#{classroom.slug}.#{@request.host}"
        get(:edit, :lecture_id => lecture.slug, :id => grade.id,
            :assignment_id => assignment.slug,
            :use_route => :coursewareable)
      end

      it { should redirect_to(login_path) }
    end
  end

  describe 'PUT update' do
    let(:grade) do
      Fabricate('coursewareable/grade',
                :classroom => classroom, :assignment => assignment)
    end

    context 'not being logged in' do
      before do
        @request.host = "#{classroom.slug}.#{@request.host}"
        put(:update, :lecture_id => lecture.slug, :id => grade.id,
            :assignment_id => assignment.slug, :use_route => :coursewareable)
      end

      it { should redirect_to(login_path) }
    end
  end

  describe 'DELETE destroy' do
    let(:grade) do
      Fabricate('coursewareable/grade',
                :classroom => classroom, :assignment => assignment)
    end

    context 'not being logged in' do
      before do
        @request.host = "#{classroom.slug}.#{@request.host}"
        delete(:destroy, :lecture_id => lecture.slug, :id => grade.id,
            :assignment_id => assignment.slug, :use_route => :coursewareable)
      end

      it { should redirect_to(login_path) }
    end
  end

  describe 'GET index' do
    let(:grade) do
      Fabricate('coursewareable/grade',
                :classroom => classroom, :assignment => assignment)
    end

    context 'not being logged in' do
      before do
        @request.host = "#{classroom.slug}.#{@request.host}"
        get(:index, :lecture_id => lecture.slug,
            :assignment_id => assignment.slug, :use_route => :coursewareable)
      end

      it { should redirect_to(login_path) }
    end
  end

end
