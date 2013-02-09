require 'spec_helper'

describe Coursewareable::AssignmentsController do
  let(:lecture) { Fabricate('coursewareable/lecture') }
  let(:classroom) { lecture.classroom }
  let(:collaboration) { Fabricate('coursewareable/collaboration',
                               :classroom => classroom) }
  let(:collaborator) { collaboration.user }

  describe 'GET new' do
    before(:each) do
      @controller.send(:auto_login, collaborator)
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:new, :lecture_id => lecture.slug, :use_route => :coursewareable)
    end

    context 'being logged in as a collaborator' do
      it { should render_template(:new) }
    end
  end

  describe 'GET show' do
    let(:assignment) { Fabricate('coursewareable/assignment',
      :lecture => lecture, :classroom => classroom, :user => classroom.owner) }

    before(:each) do
      @controller.send(:auto_login, collaborator)
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:show, :lecture_id => lecture.slug, :use_route => :coursewareable,
          :id => assignment.slug )
    end

    context 'being logged in as a collaborator' do
      it { should render_template(:show) }
    end
  end

  describe 'GET edit' do
    let(:assignment) { Fabricate('coursewareable/assignment',
      :lecture => lecture, :classroom => classroom, :user => classroom.owner) }

    before(:each) do
      @controller.send(:auto_login, collaborator)
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:edit, :lecture_id => lecture.slug, :use_route => :coursewareable,
          :id => assignment.slug )
    end

    context 'being logged in as a collaborator' do
      it { should render_template(:edit) }
    end
  end

  describe 'POST create' do
    let(:attrs) { Fabricate.build('coursewareable/assignment') }
    let(:has_quiz) { true }
    let(:quiz_data) do
      [ {
        :options => [{
          :valid => true,
          :content => "Correct"
        }, {
          :valid => false,
          :content => "Wrong"
        }],
        :content => "Radio Question Title",
        :type => "radios"
      } ]
    end

    before(:each) do
      @controller.send(:auto_login, collaborator)
      @request.host = "#{classroom.slug}.#{@request.host}"
      post(:create, :lecture_id => lecture.slug, :assignment => {
        :title => attrs.title, :content => attrs.content, :quiz => quiz_data },
        :use_route => :coursewareable, :has_quiz => has_quiz )
    end

    context 'being logged in as a collaborator' do
      subject { lecture.assignments.first }
      it do
        should redirect_to(lecture_assignment_path(lecture, subject))
        subject.title.should eq(attrs.title)
        subject.quiz.first['options'].size.should eq(2)
        subject.quiz.first[:content].should eq(quiz_data.first['content'])
        subject.quiz.first[:type].should eq(quiz_data.first['type'])
      end

      context 'with no quiz data' do
        let(:has_quiz) { false }
        it do
          should redirect_to(lecture_assignment_path(lecture, subject))
          subject.title.should eq(attrs.title)
          subject.quiz.should be_nil
        end
      end
    end
  end

  describe 'PUT update' do
    let(:assignment) { Fabricate('coursewareable/assignment',
      :lecture => lecture, :classroom => classroom, :user => classroom.owner) }
    let(:attrs) { Fabricate.build('coursewareable/assignment') }
    let(:has_quiz) { true }
    let(:quiz_data) do
      [ {
        :options => [{
          :valid => true,
          :content => "Correct"
        }, {
          :valid => false,
          :content => "Wrong"
        }],
        :content => "Radio Question Title",
        :type => "radios"
      } ]
    end

    before(:each) do
      @controller.send(:auto_login, collaborator)
      @request.host = "#{classroom.slug}.#{@request.host}"
      put(:update, :lecture_id => lecture.slug, :assignment => {
        :title => attrs.title, :content => attrs.content, :quiz => quiz_data },
        :use_route => :coursewareable, :has_quiz => has_quiz,
        :id => assignment.slug )

      assignment.reload
    end

    context 'being logged in as a collaborator' do
      it do
        should redirect_to(lecture_assignment_path(lecture, assignment))
        assignment.title.should eq(attrs.title)
        assignment.quiz.first[:content].should eq(quiz_data.first['content'])
      end

      context 'with no quiz data' do
        let(:has_quiz) { false }

        it do
          should redirect_to(lecture_assignment_path(lecture, assignment))
          assignment.title.should eq(attrs.title)
          assignment.quiz.should be_nil
        end
      end
    end
  end

  describe 'DELETE destroy' do
    let(:assignment) { Fabricate('coursewareable/assignment',
      :lecture => lecture, :classroom => classroom, :user => classroom.owner) }

    before(:each) do
      @controller.send(:auto_login, collaborator)
      @request.host = "#{classroom.slug}.#{@request.host}"
      delete(:destroy, :lecture_id => lecture.slug, :id => assignment.slug,
             :use_route => :coursewareable )
    end

    context 'being logged in as a collaborator' do
      it do
        should redirect_to(lecture_path(lecture))
        lecture.assignments.should be_empty
      end
    end
  end
end

