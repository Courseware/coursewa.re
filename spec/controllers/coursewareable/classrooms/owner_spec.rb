require 'spec_helper'

describe Coursewareable::ClassroomsController do

  let(:classroom) { Fabricate('coursewareable/classroom') }

  describe 'GET dashboard' do
    before do
      @controller.send(:auto_login, classroom.owner)
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:dashboard, :use_route => :coursewareable)
    end

    context 'being logged in as owner' do
      it { should render_template(:dashboard) }
    end
  end

  describe 'GET new' do
    before do
      @controller.send(:auto_login, classroom.owner)
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:new, :use_route => :coursewareable)
    end

    context 'being logged in as owner' do
      it { should redirect_to(login_path) }

      context 'with plan limits allowed to create a classroom' do
        before(:all) { classroom.owner.plan.increment!(:allowed_classrooms) }
        it { should render_template(:new) }
      end
    end
  end

  describe 'POST :create' do
    let(:attrs) { Fabricate.build('coursewareable/classroom') }

    before do
      @controller.send(:auto_login, classroom.owner)
      @request.host = "#{classroom.slug}.#{@request.host}"
      post(:create, :use_route => :coursewareable, :classroom => {
        :title => attrs.title, :description => attrs.description
      })
    end

    context 'being logged in as owner' do
      it { should redirect_to(login_path) }

      context 'with plan limits allowed to create a classroom' do
        before(:all) { classroom.owner.plan.increment!(:allowed_classrooms) }
        it { should redirect_to(classroom_url(
          :subdomain => classroom.owner.created_classrooms.last.slug))
        }
      end
    end
  end

  describe 'GET edit' do
    before do
      @controller.send(:auto_login, classroom.owner)
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:edit, :use_route => :coursewareable)
    end

    context 'being logged in as owner' do
      it { should render_template(:edit) }
    end
  end

  describe 'PUT update' do
    let(:attrs) { Fabricate.build('coursewareable/classroom') }

    before do
      @controller.send(:auto_login, classroom.owner)
      @request.host = "#{classroom.slug}.#{@request.host}"
      put(:update, :use_route => :coursewareable, :classroom => {
        :title => attrs.title, :description => attrs.description
      })
    end

    context 'being logged in as owner' do
      before { classroom.reload }
      it { should redirect_to(edit_classroom_url(:subdomain => classroom.slug)) }
      it { classroom.title.should eq(attrs.title) }
    end
  end

end
