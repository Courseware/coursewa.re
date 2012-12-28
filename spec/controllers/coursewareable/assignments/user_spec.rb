require 'spec_helper'

describe Coursewareable::AssignmentsController do
  let(:lecture) { Fabricate('coursewareable/lecture') }
  let(:classroom) { lecture.classroom }
  let(:user) { Fabricate(:confirmed_user) }

  describe 'GET new' do
    before(:each) do
      @controller.send(:auto_login, user)
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:new, :lecture_id => lecture.slug, :use_route => :coursewareable)
    end

    context 'being logged in as a user' do
      it { should redirect_to(login_path) }
    end
  end

  describe 'GET show' do
    let(:assignment) { Fabricate('coursewareable/assignment',
      :lecture => lecture, :classroom => classroom, :user => classroom.owner) }

    before(:each) do
      @controller.send(:auto_login, user)
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:show, :lecture_id => lecture.slug, :use_route => :coursewareable,
          :id => assignment.slug )
    end

    context 'being logged in as a user' do
      it { should redirect_to(login_path) }
    end
  end

  describe 'GET edit' do
    let(:assignment) { Fabricate('coursewareable/assignment',
      :lecture => lecture, :classroom => classroom, :user => classroom.owner) }

    before(:each) do
      @controller.send(:auto_login, user)
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:edit, :lecture_id => lecture.slug, :use_route => :coursewareable,
          :id => assignment.slug )
    end

    context 'being logged in as a user' do
      it { should redirect_to(login_path) }
    end
  end

  describe 'POST create' do
    let(:attrs) { Fabricate.build('coursewareable/assignment') }
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
      @controller.send(:auto_login, user)
      @request.host = "#{classroom.slug}.#{@request.host}"
      post(:create, :lecture_id => lecture.slug, :assignment => {
        :title => attrs.title, :content => attrs.content, :quiz => quiz_data },
        :use_route => :coursewareable )
    end

    context 'being logged in as a user' do
      it { should redirect_to(login_path) }
    end
  end

  describe 'PUT update' do
    let(:assignment) { Fabricate('coursewareable/assignment',
      :lecture => lecture, :classroom => classroom, :user => classroom.owner) }
    let(:attrs) { Fabricate.build('coursewareable/assignment') }
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
      @controller.send(:auto_login, user)
      @request.host = "#{classroom.slug}.#{@request.host}"
      put(:update, :lecture_id => lecture.slug, :assignment => {
        :title => attrs.title, :content => attrs.content, :quiz => quiz_data },
        :use_route => :coursewareable, :id => assignment.slug )
    end

    context 'being logged in as a user' do
      it { should redirect_to(login_path) }
    end
  end

  describe 'DELETE destroy' do
    let(:assignment) { Fabricate('coursewareable/assignment',
      :lecture => lecture, :classroom => classroom, :user => classroom.owner) }

    before(:each) do
      @controller.send(:auto_login, user)
      @request.host = "#{classroom.slug}.#{@request.host}"
      delete(:destroy, :lecture_id => lecture.slug, :id => assignment.slug,
             :use_route => :coursewareable )
    end

    context 'being logged in as a user' do
      it { should redirect_to(login_path) }
    end
  end
end
