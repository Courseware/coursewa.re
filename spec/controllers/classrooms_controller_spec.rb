require 'spec_helper'

describe ClassroomsController do

  describe 'GET dashboard' do

    let(:classroom) { Fabricate(:classroom) }

    context 'not being logged in' do
      it 'should redirect to login' do
        @request.host = "#{classroom.slug}.#{@request.host}"
        get :dashboard
        response.should redirect_to(login_path)
      end

      it 'should redirect to not found if classroom does not exist' do
        @request.host = "wrong.#{@request.host}"
        get :dashboard
        response.should redirect_to(login_path)
      end
    end

    context 'being logged in' do
      it 'should show dashboard' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "#{classroom.slug}.#{@request.host}"
        get :dashboard
        response.should render_template(:dashboard)
      end

      it 'should redirect to not found if classroom does not exist' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "missing.#{@request.host}"
        get :dashboard
        response.should redirect_to('/404')
      end
    end
  end

  describe 'GET new' do

    let(:user) { Fabricate(:confirmed_user) }

    context 'not being logged in' do
      it 'should redirect to login' do
        get :new
        response.should redirect_to(login_url)
      end
    end

    context 'being logged in' do
      before{ @controller.send(:auto_login, user) }

      it 'should show classroom creation screen' do
        get :new
        response.should render_template(:new)
      end

    end
  end

end
