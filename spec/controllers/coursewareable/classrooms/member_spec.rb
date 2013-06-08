require 'spec_helper'

describe Coursewareable::ClassroomsController do

  let(:classroom) { Fabricate('coursewareable/classroom') }
  let(:membership) {
    Fabricate('coursewareable/membership', :classroom => classroom) }
  let(:member) { membership.user }

  describe 'GET dashboard' do
    context 'http request' do
      before do
        @controller.send(:auto_login, member)
        @request.host = "#{classroom.slug}.#{@request.host}"
        get(:dashboard, :use_route => :coursewareable)
      end

      context 'being logged in as member' do
        it { should render_template(:dashboard) }
      end
    end

    context 'xhr request' do
      before do
        @request.host = "#{classroom.slug}.#{@request.host}"
        xhr(:get, :dashboard, :use_route => :coursewareable)
      end
      it { should redirect_to(login_path) }

      context 'when logged in as a member' do
        before(:all) do
          setup_controller_request_and_response
          @controller.send(:auto_login, member)
        end

        it { should render_template(:timeline) }
      end
    end
  end

  describe 'GET new' do
    before do
      @controller.send(:auto_login, member)
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:new, :use_route => :coursewareable)
    end

    context 'being logged in as member' do
      it { should render_template(:new) }

      context 'with plan allowed classrooms limits reached' do
        before(:all) { member.plan.decrement!(:allowed_classrooms, 100) }
        it { should redirect_to(login_path) }
      end
    end
  end

  describe 'GET staff' do
    before do
      @controller.send(:auto_login, member)
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:staff, :use_route => :coursewareable)
    end

    context 'being logged in as member' do
      it { should render_template(:staff) }
    end
  end

  describe 'GET staff' do
    let(:format) { :html }
    before do
      @controller.send(:auto_login, member)
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:stats, :use_route => :coursewareable, :format => format)
    end

    context 'being logged in as owner' do
      it { should render_template(:stats) }

      context 'format is json' do
        let(:format) { :json }

        it 'renders all activities as JSON' do
          data = JSON.parse(response.body)
          data.count.should eq(classroom.all_activities.count)
          data.first.keys.count.should eq(2)
        end
      end
    end

  end

  describe 'POST :create' do
    let(:attrs) { Fabricate.build('coursewareable/classroom') }

    before do
      @controller.send(:auto_login, member)
      @request.host = "#{classroom.slug}.#{@request.host}"
      post(:create, :use_route => :coursewareable, :classroom => {
        :title => attrs.title, :description => attrs.description
      })
    end

    context 'being logged in as member' do
      it { should redirect_to(classroom_url(
        :subdomain => member.created_classrooms.last.slug))
      }

      context 'with plan allowed classrooms limits reached' do
        before(:all) { member.plan.decrement!(:allowed_classrooms, 100) }
        it { should redirect_to(login_path) }
      end
    end
  end

  describe 'GET edit' do
    before do
      @controller.send(:auto_login, member)
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:edit, :use_route => :coursewareable)
    end

    context 'being logged in as member' do
      it { should redirect_to(login_path) }
    end
  end

  describe 'PUT update' do
    let(:attrs) { Fabricate.build('coursewareable/classroom') }

    before do
      @controller.send(:auto_login, member)
      @request.host = "#{classroom.slug}.#{@request.host}"
      put(:update, :use_route => :coursewareable, :classroom => {
        :title => attrs.title, :description => attrs.description
      })
    end

    context 'being logged in as member' do
      it { should redirect_to(login_path) }
    end
  end

  describe 'POST announce' do
    let(:attrs) { Fabricate.build('coursewareable/classroom') }

    before do
      @request.host = "#{classroom.slug}.#{@request.host}"
      post(:announce, :use_route => :coursewareable,
           :announcement => attrs.description)
    end

    context 'logged in as a member' do
      it { should redirect_to(login_path) }
    end
  end
end
