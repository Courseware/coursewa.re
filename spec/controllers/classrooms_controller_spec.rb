require 'spec_helper'

describe ClassroomsController do

  let(:classroom) { Fabricate(:classroom) }

  describe 'GET dashboard' do
    context 'being not logged in' do
      it 'should redirect to login' do
        @request.host = "#{classroom.slug}.lvh.me"
        get :dashboard
        response.should redirect_to(login_path)
      end

      it 'should redirect to not found if classroom does not exist' do
        @request.host = '123.lvh.me'
        get :dashboard
        response.should redirect_to(login_path)
      end
    end

    context 'being logged in' do
      it 'should show dashboard' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "#{classroom.slug}.lvh.me"
        get :dashboard
        response.should render_template(:dashboard)
      end

      it 'should redirect to not found if classroom does not exist' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = '123.lvh.me'
        get :dashboard
        response.should redirect_to('/404')
      end
    end
  end

end
