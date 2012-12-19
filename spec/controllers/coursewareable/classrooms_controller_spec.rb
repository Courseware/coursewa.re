require 'spec_helper'

describe Coursewareable::ClassroomsController do

  describe 'GET dashboard' do

    let(:classroom) { Fabricate('coursewareable/classroom') }

    context 'not being logged in' do
      it 'should redirect to login' do
        @request.host = "#{classroom.slug}.#{@request.host}"
        get :dashboard, :use_route => :coursewareable
        response.should redirect_to(login_path)
      end

      it 'should redirect to login if classroom does not exist' do
        @request.host = "wrong.#{@request.host}"
        get :dashboard, :use_route => :coursewareable
        response.should redirect_to(login_path)
      end
    end

    context 'being logged in' do
      it 'should show dashboard' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "#{classroom.slug}.#{@request.host}"
        get :dashboard, :use_route => :coursewareable
        response.should render_template(:dashboard)
      end

      it 'should redirect to not found if classroom does not exist' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "missing.#{@request.host}"
        get :dashboard, :use_route => :coursewareable
        response.should redirect_to('/404')
      end
    end
  end

  describe 'GET new' do

    let(:user) { Fabricate(:confirmed_user) }

    context 'not being logged in' do
      it 'should redirect to login' do
        get :new, :use_route => :coursewareable
        response.should redirect_to(login_path)
      end
    end

    context 'being logged in' do
      before{ @controller.send(:auto_login, user) }

      it 'should show classroom creation screen' do
        get :new, :use_route => :coursewareable
        response.should render_template(:new)
      end

    end
  end

  describe 'POST :create' do

    context 'not being logged in' do
      it 'should redirect to login' do
        post :create, :use_route => :coursewareable
        response.should redirect_to(login_path)
      end
    end

    context 'being logged in' do
      let(:user) { Fabricate(:confirmed_user) }

      it 'should show classroom creation screen on empty request' do
        @controller.send(:auto_login, user)
        post :create, :use_route => :coursewareable
        response.should redirect_to(start_classroom_path)
      end

      it 'should create and redirect to the new classroom' do
        @controller.send(:auto_login, user)
        title = Faker::Education.school[0..31]
        post :create, :use_route => :coursewareable, :classroom => {
          :title => title,
          :description => Faker::HTMLIpsum.fancy_string
        }
        response.should redirect_to(
          root_url(:subdomain => title.parameterize, :host => 'test.host'))
      end
    end

    context 'and with plan limits reached' do
      let(:user) { Fabricate('coursewareable/classroom').owner.reload }

      it 'should redirect to login (not authorized)' do
        @controller.send(:auto_login, user)
        post :create, :use_route => :coursewareable, :classroom => {
          :title => Faker::Education.school[0..31],
          :description => Faker::HTMLIpsum.fancy_string
        }
        response.should redirect_to(login_path)
      end
    end

  end

  describe 'GET edit' do

    let!(:classroom) { Fabricate('coursewareable/classroom') }

    context 'not being logged in' do
      it 'should redirect to login' do
        @request.host = "#{classroom.slug}.#{@request.host}"
        get :edit, :use_route => :coursewareable
        response.should redirect_to(login_path)
      end
    end

    context 'being logged in' do
      before{ @controller.send(:auto_login, classroom.owner) }

      it 'should show edit screen' do
        @request.host = "#{classroom.slug}.#{@request.host}"
        get :edit, :use_route => :coursewareable
        response.should render_template(:edit)
      end
    end
  end

  describe 'PUT update' do

    let!(:classroom) { Fabricate('coursewareable/classroom') }

    context 'not being logged in' do
      it 'should redirect to login' do
        @request.host = "#{classroom.slug}.#{@request.host}"
        put :update, :use_route => :coursewareable
        response.should redirect_to(login_path)
      end
    end

    context 'being logged in' do
      before{ @controller.send(:auto_login, classroom.owner) }

      it 'should update classroom' do
        @request.host = "#{classroom.slug}.#{@request.host}"
        title = Faker::Education.school[0..31]
        content = Faker::HTMLIpsum.fancy_string

        put(
          :update, :classroom => {:title => title, :description => content},
          :use_route => :coursewareable
        )

        classroom.reload
        classroom.title.should eq(title)
        classroom.description.should eq(
          Sanitize.clean(content, Sanitize::Config::RESTRICTED))

        response.should redirect_to(edit_classroom_url(
          :subdomain => classroom.slug))
      end

    end
  end

end
