require 'spec_helper'

describe Coursewareable::ClassroomsController do

  let(:classroom) { Fabricate('coursewareable/classroom') }
  let(:collaboration) {
    Fabricate('coursewareable/collaboration', :classroom => classroom) }
  let(:collaborator) { collaboration.user }

  describe 'GET dashboard' do
    before do
      @controller.send(:auto_login, collaborator)
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:dashboard, :use_route => :coursewareable)
    end

    context 'being logged in as collaborator' do
      it { should render_template(:dashboard) }
    end
  end

  describe 'GET new' do
    before do
      @controller.send(:auto_login, collaborator)
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:new, :use_route => :coursewareable)
    end

    context 'being logged in as collaborator' do
      it { should render_template(:new) }

      context 'with plan allowed classrooms limits reached' do
        before(:all) { collaborator.plan.decrement!(:allowed_classrooms, 100) }
        it { should redirect_to(login_path) }
      end
    end
  end

  describe 'POST :create' do
    let(:attrs) { Fabricate.build('coursewareable/classroom') }

    before do
      @controller.send(:auto_login, collaborator)
      @request.host = "#{classroom.slug}.#{@request.host}"
      post(:create, :use_route => :coursewareable, :classroom => {
        :title => attrs.title, :description => attrs.description
      })
    end

    context 'being logged in as collaborator' do
      it { should redirect_to(classroom_url(
        :subdomain => collaborator.created_classrooms.last.slug))
      }

      context 'with plan allowed classrooms limits reached' do
        before(:all) { collaborator.plan.decrement!(:allowed_classrooms, 100) }
        it { should redirect_to(login_path) }
      end
    end
  end

  describe 'GET edit' do
    before do
      @controller.send(:auto_login, collaborator)
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:edit, :use_route => :coursewareable)
    end

    context 'being logged in as collaborator' do
      it { should redirect_to(login_path) }
    end
  end

  describe 'PUT update' do
    let(:attrs) { Fabricate.build('coursewareable/classroom') }

    before do
      @controller.send(:auto_login, collaborator)
      @request.host = "#{classroom.slug}.#{@request.host}"
      put(:update, :use_route => :coursewareable, :classroom => {
        :title => attrs.title, :description => attrs.description
      })
    end

    context 'being logged in as collaborator' do
      it { should redirect_to(login_path) }
    end
  end

end
