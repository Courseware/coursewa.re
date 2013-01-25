require 'spec_helper'

describe Coursewareable::CollaborationsController do

  let(:classroom) { Fabricate('coursewareable/classroom') }
  let(:membership) do
    Fabricate('coursewareable/membership', :classroom => classroom)
  end

  let(:member) { membership.user }

  describe 'GET index' do
    before(:each) do
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:index, :use_route => :coursewareable)
    end

    context 'being logged in as a member' do
      before(:all) do
        setup_controller_request_and_response
        @controller.send(:auto_login, member)
      end

      it { should redirect_to(login_path) }
    end
  end

  describe 'POST create' do
    let(:email) { '' }
    before(:each) do
      @request.host = "#{classroom.slug}.#{@request.host}"
      post(:create, :email => email, :use_route => :coursewareable)
    end

    context 'being logged in as a member' do
      before(:all) do
        setup_controller_request_and_response
        @controller.send(:auto_login, member)
      end

      it { should redirect_to(login_path) }
    end
  end

  describe 'DELETE destroy' do
    let(:collaboration) do
      Fabricate('coursewareable/collaboration', :classroom => classroom)
    end

    before(:each) do
      @request.host = "#{classroom.slug}.#{@request.host}"
      delete(:destroy, :id => collaboration.id,
             :use_route => :coursewareable)
    end

    context 'being logged in as a member' do
      before(:all) do
        setup_controller_request_and_response
        @controller.send(:auto_login, member)
      end

      it { should redirect_to(login_path) }
    end
  end

end
