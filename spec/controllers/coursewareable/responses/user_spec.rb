require 'spec_helper'

describe Coursewareable::ResponsesController do

  let(:assignment) { Fabricate('coursewareable/assignment') }
  let(:classroom) { assignment.classroom }
  let(:lecture) { assignment.lecture }
  let(:user) { Fabricate(:confirmed_user) }

  describe 'GET new' do
    context 'being logged in as a user' do
      before do
        @controller.send(:auto_login, user)
        @request.host = "#{classroom.slug}.#{@request.host}"
        get(:new, :lecture_id => lecture.slug,
            :assignment_id => assignment.slug, :use_route => :coursewareable)
      end

      it { should redirect_to(login_path) }
    end
  end

  describe 'POST create' do
    context 'being logged in as a user' do
      before do
        @controller.send(:auto_login, user)
        @request.host = "#{classroom.slug}.#{@request.host}"
        post(:create, :lecture_id => lecture.slug,
            :assignment_id => assignment.slug, :use_route => :coursewareable,
            :response => { :content => Faker::HTMLIpsum.body })
      end

      it { should redirect_to(login_path) }
    end
  end

  describe 'GET show' do
    let(:resp) do
      Fabricate('coursewareable/response', :classroom => classroom,
                :assignment => assignment)
    end

    context 'being logged in as a user' do
      before do
        @controller.send(:auto_login, user)
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

    context 'being logged in as a user' do
      before do
        @controller.send(:auto_login, user)
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

