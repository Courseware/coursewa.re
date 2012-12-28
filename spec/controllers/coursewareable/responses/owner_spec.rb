require 'spec_helper'

describe Coursewareable::ResponsesController do

  let(:assignment) { Fabricate('coursewareable/assignment') }
  let(:classroom) { assignment.classroom }
  let(:lecture) { assignment.lecture }

  describe 'GET new' do
    context 'classroom is not owned' do
      let(:assignment_two) { Fabricate('coursewareable/assignment') }

      before do
        @request.host = "#{assignment_two.classroom.slug}.#{@request.host}"
        @controller.send(:auto_login, classroom.owner)
        get(:new, :lecture_id => assignment_two.lecture.slug,
            :assignment_id => assignment_two.slug,
            :use_route => :coursewareable)
      end

      it { should redirect_to(login_path) }
      its('flash.keys') { should include(:alert) }
    end

    context 'being logged in as owner' do
      before(:each) do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "#{classroom.slug}.#{@request.host}"
      end

      context 'where classroom, lecture and assignment exists' do
        before do
          get(:new, :lecture_id => lecture.slug,
              :assignment_id => assignment.slug,
              :use_route => :coursewareable)
        end

        it { should redirect_to(login_path) }

        context 'classroom is wrong' do
          let(:classroom) { Fabricate('coursewareable/classroom') }

          it { should redirect_to('/404') }
        end

      end
    end
  end

  describe 'POST create' do
    context 'classroom is not owned' do
      let(:assignment_two) { Fabricate('coursewareable/assignment') }

      before do
        @request.host = "#{assignment_two.classroom.slug}.#{@request.host}"
        @controller.send(:auto_login, classroom.owner)
        post(:create, :lecture_id => assignment_two.lecture.slug,
            :assignment_id => assignment_two.slug,
            :use_route => :coursewareable)
      end

      it { should redirect_to(login_path) }
      its('flash.keys') { should include(:alert) }
    end

    context 'being logged in as owner' do
      before(:each) do
        @controller.send(:auto_login, classroom.owner)
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

    context 'classroom is not owned' do
      let(:resp_two) { Fabricate('coursewareable/response') }

      before do
        @request.host = "#{resp_two.classroom.slug}.#{@request.host}"
        @controller.send(:auto_login, classroom.owner)
        get(:show, :lecture_id => resp_two.assignment.lecture.slug,
            :assignment_id => resp_two.assignment.slug,
            :id => resp_two.id,
            :use_route => :coursewareable)
      end

      it { should redirect_to(login_path) }
      its('flash.keys') { should include(:alert) }
    end

    context 'being logged in as owner' do
      before(:each) do
        @controller.send(:auto_login, classroom.owner)
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

    context 'classroom is not owned' do
      let(:resp_two) { Fabricate('coursewareable/response') }

      before do
        @request.host = "#{resp_two.classroom.slug}.#{@request.host}"
        @controller.send(:auto_login, classroom.owner)
        delete(:destroy, :lecture_id => resp_two.assignment.lecture.slug,
            :assignment_id => resp_two.assignment.slug,
            :id => resp_two.id,
            :use_route => :coursewareable)
      end

      it { should redirect_to(login_path) }
      its('flash.keys') { should include(:alert) }
    end

    context 'being logged in as owner' do
      before(:each) do
        @controller.send(:auto_login, classroom.owner)
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
