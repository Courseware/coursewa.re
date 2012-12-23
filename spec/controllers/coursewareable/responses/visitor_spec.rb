require 'spec_helper'

describe Coursewareable::ResponsesController do

  let(:assignment) { Fabricate('coursewareable/assignment') }
  let(:classroom) { assignment.classroom }
  let(:lecture) { assignment.lecture }

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
    context 'not being logged in' do
      before do
        @request.host = "#{classroom.slug}.#{@request.host}"
        post(:create, :lecture_id => lecture.slug,
            :assignment_id => assignment.slug, :use_route => :coursewareable)
      end

      it { should redirect_to(login_path) }
    end
  end

  describe 'GET show' do
    let(:resp) do
      Fabricate('coursewareable/response', :classroom => classroom,
                :assignment => assignment)
    end

    context 'not being logged in' do
      before do
        @request.host = "#{classroom.slug}.#{@request.host}"
        get(:show, :lecture_id => lecture.slug,
            :assignment_id => assignment.slug,
            :id => resp.id,
            :use_route => :coursewareable)
      end

      it { should redirect_to(login_path) }
    end
  end

  describe 'DELETE destroy' do
    let(:resp) do
      Fabricate('coursewareable/response', :classroom => classroom,
                :assignment => assignment)
    end

    context 'not being logged in' do
      before do
        @request.host = "#{classroom.slug}.#{@request.host}"
        delete(:destroy, :lecture_id => lecture.slug,
            :assignment_id => assignment.slug,
            :id => resp.id,
            :use_route => :coursewareable)
      end

      it { should redirect_to(login_path) }
    end
  end
end
