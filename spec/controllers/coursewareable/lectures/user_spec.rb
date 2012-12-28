require 'spec_helper'

describe Coursewareable::LecturesController do

  let(:classroom) { Fabricate('coursewareable/classroom') }
  let(:user) { Fabricate(:confirmed_user) }

  describe 'GET new' do
    before(:each) do
      @controller.send(:auto_login, user)
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:new, :use_route => :coursewareable)
    end

    context 'being logged in as a user' do
      it { should redirect_to(login_path) }
    end
  end

  describe 'GET show' do
    let(:lecture) { Fabricate('coursewareable/lecture',
      :user => classroom.owner, :classroom => classroom) }

    before(:each) do
      @controller.send(:auto_login, user)
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:show, :id => lecture.id, :use_route => :coursewareable)
    end

    context 'being logged in as a user' do
      it { should redirect_to(login_path) }
    end
  end

  describe 'GET edit' do
    let(:lecture) { Fabricate('coursewareable/lecture',
      :user => classroom.owner, :classroom => classroom) }

    before(:each) do
      @controller.send(:auto_login, user)
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:edit, :id => lecture.id, :use_route => :coursewareable)
    end

    context 'being logged in as a user' do
      it { should redirect_to(login_path) }
    end
  end

  describe 'POST create' do
    let(:lecture) { Fabricate.build('coursewareable/lecture') }

    before(:each) do
      @controller.send(:auto_login, user)
      @request.host = "#{classroom.slug}.#{@request.host}"
      post(:create, :use_route => :coursewareable, :lecture => {
        :title => lecture.title, :content => lecture.content,
        :requisite => lecture.requisite
      })
    end

    context 'being logged in as a user' do
      it { should redirect_to(login_path) }
    end
  end

  describe 'PUT update' do
    let(:lecture) { Fabricate('coursewareable/lecture',
      :user => classroom.owner, :classroom => classroom) }
    let(:attrs) { Fabricate.build('coursewareable/lecture') }

    before(:each) do
      @controller.send(:auto_login, user)
      @request.host = "#{classroom.slug}.#{@request.host}"
      put(:update, :use_route => :coursewareable, :id => lecture.id,
          :lecture => { :title => attrs.title, :content => attrs.content
      } )
    end

    context 'being logged in as a user' do
      it { should redirect_to(login_path) }
    end
  end

  describe 'DELETE destroy' do
    let(:lecture) { Fabricate('coursewareable/lecture',
      :classroom => classroom, :user => classroom.owner) }

    before(:each) do
      @controller.send(:auto_login, user)
      @request.host = "#{classroom.slug}.#{@request.host}"
      delete(:destroy, :use_route => :coursewareable, :id => lecture.id)
    end

    context 'being logged in as a user' do
      it { should redirect_to(login_path) }
    end
  end
end

