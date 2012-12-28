require 'spec_helper'

describe Coursewareable::ResponsesController do

  let(:collaborator) { Fabricate(:confirmed_user) }
  let(:assignment) { Fabricate('coursewareable/assignment') }
  let(:classroom) { assignment.classroom }
  let(:lecture) { assignment.lecture }

  before { classroom.collaborators << collaborator }

  describe 'GET new' do
    context 'not a collaborator for this classroom' do
      let(:assignment_two) { Fabricate('coursewareable/assignment') }

      before do
        @request.host = "#{assignment_two.classroom.slug}.#{@request.host}"
        @controller.send(:auto_login, collaborator)
        get(:new, :lecture_id => assignment_two.lecture.slug,
            :assignment_id => assignment_two.slug,
            :use_route => :coursewareable)
      end

      it { should redirect_to(login_path) }
      its('flash.keys') { should include(:alert) }
    end

    context 'being logged in as a collaborator' do
      before(:each) do
        @controller.send(:auto_login, collaborator)
        @request.host = "#{classroom.slug}.#{@request.host}"
      end

      context 'where classroom, lecture and assignment exists' do
        before do
          get(:new, :lecture_id => lecture.slug,
              :assignment_id => assignment.slug,
              :use_route => :coursewareable)
        end

        it { should redirect_to(login_path) }
      end
    end
  end

  describe 'POST create' do
    context 'not a collaborator for this classroom' do
      let(:assignment_two) { Fabricate('coursewareable/assignment') }

      before do
        @request.host = "#{assignment_two.classroom.slug}.#{@request.host}"
        @controller.send(:auto_login, collaborator)
        post(:create, :lecture_id => assignment_two.lecture.slug,
            :assignment_id => assignment_two.slug,
            :use_route => :coursewareable)
      end

      it { should redirect_to(login_path) }
      its('flash.keys') { should include(:alert) }
    end

    context 'being logged in as collaborator' do
      before(:each) do
        @controller.send(:auto_login, collaborator)
        @request.host = "#{classroom.slug}.#{@request.host}"
      end

      context 'where classroom, lecture and assignment exists' do
        before do
          post(:create, :lecture_id => lecture.slug,
              :assignment_id => assignment.slug,
              :use_route => :coursewareable)
        end

        it { should redirect_to(login_path) }
      end
    end
  end

  describe 'GET show' do
    let(:resp) do
      Fabricate('coursewareable/response', :classroom => classroom,
                :assignment => assignment)
    end

    context 'not a collaborator for this classroom' do
      let(:resp_two) { Fabricate('coursewareable/response') }

      before do
        @request.host = "#{resp_two.classroom.slug}.#{@request.host}"
        @controller.send(:auto_login, collaborator)
        get(:show, :lecture_id => resp_two.assignment.lecture.slug,
            :assignment_id => resp_two.assignment.slug,
            :id => resp_two.id,
            :use_route => :coursewareable)
      end

      it { should redirect_to(login_path) }
      its('flash.keys') { should include(:alert) }
    end

    context 'being logged in as collaborator' do
      before(:each) do
        @controller.send(:auto_login, collaborator)
        @request.host = "#{classroom.slug}.#{@request.host}"
      end

      context 'where classroom, lecture and assignment exists' do
        before do
        get(:show, :lecture_id => lecture.slug,
            :assignment_id => assignment.slug,
            :id => resp.id,
            :use_route => :coursewareable)
        end

        it { should render_template(:show) }
      end
    end
  end

  describe 'DELETE destroy' do
    let(:resp) do
      Fabricate('coursewareable/response', :classroom => classroom,
                :assignment => assignment)
    end

    context 'not being a collaborator for this classroom' do
      let(:resp_two) { Fabricate('coursewareable/response') }

      before do
        @request.host = "#{resp_two.classroom.slug}.#{@request.host}"
        @controller.send(:auto_login, collaborator)
        delete(:destroy, :lecture_id => resp_two.assignment.lecture.slug,
            :assignment_id => resp_two.assignment.slug,
            :id => resp_two.id,
            :use_route => :coursewareable)
      end

      it { should redirect_to(login_path) }
      its('flash.keys') { should include(:alert) }
    end

    context 'being logged in as collaborator' do
      before(:each) do
        @controller.send(:auto_login, collaborator)
        @request.host = "#{classroom.slug}.#{@request.host}"
      end

      context 'where classroom, lecture and assignment exists' do
        before do
        delete(:destroy, :lecture_id => lecture.slug,
            :assignment_id => assignment.slug,
            :id => resp.id,
            :use_route => :coursewareable)
        end

        it { should redirect_to(lecture_assignment_path(lecture, assignment)) }
        it { expect{resp.reload}.to raise_error(ActiveRecord::RecordNotFound) }
      end
    end
  end
end
