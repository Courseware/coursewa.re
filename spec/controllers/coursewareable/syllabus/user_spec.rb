require 'spec_helper'

describe Coursewareable::SyllabusesController do

  let(:classroom) { Fabricate('coursewareable/classroom') }
  let(:user) { Fabricate(:confirmed_user) }

  describe 'GET show' do
    let(:syllabus) { Fabricate('coursewareable/syllabus',
      :user => classroom.owner, :classroom => classroom) }

    before(:each) do
      @controller.send(:auto_login, user)
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:show, :use_route => :coursewareable)
    end

    context 'being logged in as a user' do
      it { should redirect_to(login_path) }
    end
  end

  describe 'GET edit' do
    let(:syllabus) { Fabricate('coursewareable/syllabus',
      :user => classroom.owner, :classroom => classroom) }

    before(:each) do
      @controller.send(:auto_login, user)
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:edit, :use_route => :coursewareable)
    end

    context 'logged in as a user' do
      it { should redirect_to(login_path) }
    end
  end

  describe 'POST create' do
    let(:syllabus) { Fabricate.build('coursewareable/syllabus',
      :user => classroom.owner, :classroom => classroom) }

    before(:each) do
      @controller.send(:auto_login, user)
      @request.host = "#{classroom.slug}.#{@request.host}"
      post(:create, :use_route => :coursewareable, :syllabus => {
        :title => syllabus.title, :content => syllabus.content,
        :intro => syllabus.intro
      })
    end

    context 'being logged in as a user' do
      it { should redirect_to(login_path) }
    end
  end

  describe 'PUT update' do
    let(:syllabus) { Fabricate.build('coursewareable/syllabus',
      :user => classroom.owner, :classroom => classroom) }

    before(:each) do
      @controller.send(:auto_login, user)
      @request.host = "#{classroom.slug}.#{@request.host}"
      put(:update, :use_route => :coursewareable, :syllabus => {
        :title => syllabus.title, :content => syllabus.content
      })
    end

    context 'being logged in as a user' do
      it { should redirect_to(login_path) }
    end
  end

end

