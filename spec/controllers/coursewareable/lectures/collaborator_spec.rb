require 'spec_helper'

describe Coursewareable::LecturesController do

  let(:classroom) { Fabricate('coursewareable/classroom') }
  let(:collaboration) { Fabricate('coursewareable/collaboration',
                                  :classroom => classroom) }
  let(:collaborator) { collaboration.user }

  describe 'GET new' do
    before(:each) do
      @controller.send(:auto_login, collaborator)
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:new, :use_route => :coursewareable)
    end

    context 'being logged in as a collaborator' do
      it { should render_template(:new) }
    end
  end

  describe 'GET show' do
    let(:lecture) { Fabricate('coursewareable/lecture',
      :user => classroom.owner, :classroom => classroom) }

    before(:each) do
      @controller.send(:auto_login, collaborator)
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:show, :id => lecture.id, :use_route => :coursewareable)
    end

    context 'being logged in as a collaborator' do
      it { should render_template(:show) }
    end
  end

  describe 'GET edit' do
    let(:lecture) { Fabricate('coursewareable/lecture',
      :user => classroom.owner, :classroom => classroom) }

    before(:each) do
      @controller.send(:auto_login, collaborator)
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:edit, :id => lecture.id, :use_route => :coursewareable)
    end

    context 'being logged in as a collaborator' do
      it { should render_template(:edit) }
    end
  end

  describe 'POST create' do
    let(:lecture) { Fabricate.build('coursewareable/lecture') }

    before(:each) do
      @controller.send(:auto_login, collaborator)
      @request.host = "#{classroom.slug}.#{@request.host}"
      post(:create, :use_route => :coursewareable, :lecture => {
        :title => lecture.title, :content => lecture.content,
        :requisite => lecture.requisite, :position => lecture.position
      })
    end

    context 'being logged in as a collaborator' do
      it { should redirect_to(lecture_path(classroom.lectures.first)) }
    end
  end

  describe 'PUT update' do
    let(:lecture) { Fabricate('coursewareable/lecture',
      :user => classroom.owner, :classroom => classroom) }
    let(:attrs) { Fabricate.build('coursewareable/lecture') }

    before(:each) do
      @controller.send(:auto_login, collaborator)
      @request.host = "#{classroom.slug}.#{@request.host}"
      put(:update, :use_route => :coursewareable, :id => lecture.id,
          :lecture => { :title => attrs.title, :content => attrs.content
      } )
      lecture.reload
    end

    context 'being logged in as a collaborator' do
      it do
        should redirect_to(lecture_path(lecture))
        lecture.title.should eq(attrs.title)
      end
    end
  end

  describe 'DELETE destroy' do
    let(:lecture) { Fabricate('coursewareable/lecture',
      :classroom => classroom, :user => classroom.owner) }

    before(:each) do
      @controller.send(:auto_login, collaborator)
      @request.host = "#{classroom.slug}.#{@request.host}"
      delete(:destroy, :use_route => :coursewareable, :id => lecture.id)
    end

    context 'being logged in as a collaborator' do
      it do
        should redirect_to(syllabus_url)
        classroom.lectures.should be_empty
      end
    end
  end
end
