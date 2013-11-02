require 'spec_helper'

describe Coursewareable::HomesController do
  let(:user) { Fabricate(:confirmed_user) }

  describe 'GET index' do
    before { get(:index, :use_route => :coursewareable) }

    it { should render_template('coursewareable/sessions/new') }

    context 'when logged in' do
      before(:all) do
        setup_controller_request_and_response
        @controller.send(:auto_login, user)
      end

      it { should redirect_to(dashboard_home_path) }
    end
  end

  describe 'GET dashboard' do
    context 'http request' do
      before { get(:dashboard, :use_route => :coursewareable) }
      it { should redirect_to(login_path) }

      context 'when logged in' do
        before(:all) do
          setup_controller_request_and_response
          @controller.send(:auto_login, user)
        end

        it { should render_template(:dashboard) }
      end
    end

    context 'xhr request' do
      before { xhr(:get, :dashboard, :use_route => :coursewareable) }
      it { should redirect_to(login_path) }

      context 'when logged in' do
        before(:all) do
          setup_controller_request_and_response
          @controller.send(:auto_login, user)
        end

        it { should render_template(:timeline) }
      end
    end
  end

  describe 'POST feedback' do
    let(:params) { {:use_route => :coursewareable} }
    before do
      post(:feedback, params)
    end

    it { should redirect_to(root_path) }

    context 'with valid params' do
      let(:params) do
        {:use_route => :coursewareable, :name => Faker::Name.name,
        :email => Faker::Internet.email, :message => Faker::Lorem.paragraphs,
        :val1 => 1, :val2 => 2, :sum => 3}
      end

      it { redirect_to(root_path) }
      it {
        ActionMailer::Base.deliveries.last.subject.should match(params[:name])}
    end
  end

  describe 'POST survey' do
    context 'http request' do
      let(:params) { {:use_route => :coursewareable} }

      before do
        @controller.send(:auto_login, user)
        post(:survey, params)
      end

      it { should redirect_to(dashboard_home_path) }

      context 'with valid params' do
        let(:params) do
          { :use_route => :coursewareable,
            :message => Faker::Lorem.paragraphs }
        end
        before(:all) do
          GenericMailer.stub(:delay).and_return(GenericMailer)
          GenericMailer.should_receive(:survey_email)
        end

        it { should redirect_to(dashboard_home_path) }
      end
    end

    context 'xhr request' do
      let(:params) { {:use_route => :coursewareable} }

      before do
        @controller.send(:auto_login, user)
        xhr(:post, :survey, params)
      end

      it { response.should be_success }

      context 'with valid params' do
        let(:params) do
          { :use_route => :coursewareable,
            :message => Faker::Lorem.paragraphs }
        end

        before(:all) do
          GenericMailer.stub(:delay).and_return(GenericMailer)
          GenericMailer.should_receive(:survey_email)
        end

        it { response.should be_success }
      end
    end
  end

end
