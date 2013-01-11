require 'spec_helper'

describe Coursewareable::HomesController do
  let(:user) { Fabricate(:confirmed_user) }

  describe 'GET index' do
    before { get(:index, :use_route => :coursewareable) }

    it { should render_template(:index) }

    context 'when logged in' do
      before(:all) do
        setup_controller_request_and_response
        @controller.send(:auto_login, user)
      end

      it { should redirect_to(dashboard_home_path) }
    end
  end

  describe 'GET dashboard' do
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

  describe 'GET about' do
    before { get(:about, :use_route => :coursewareable) }
    it { should render_template(:about) }
  end

  describe 'GET contact' do
    before { get(:contact, :use_route => :coursewareable) }
    it { should render_template(:contact) }
  end

  describe 'POST feedback' do
    let(:params) { {:use_route => :coursewareable} }
    before do
      post(:feedback, params)
    end

    it { should redirect_to(contact_home_path) }

    context 'with valid params' do
      let(:params) do
        {:use_route => :coursewareable, :name => Faker::Name.name,
        :email => Faker::Internet.email, :message => Faker::Lorem.paragraphs,
        :val1 => 1, :val2 => 2, :sum => 3}
      end

      it { redirect_to(contact_home_path) }
      it {
        ActionMailer::Base.deliveries.last.subject.should match(params[:name])}
    end
  end

end
