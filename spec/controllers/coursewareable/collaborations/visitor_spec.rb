require 'spec_helper'

describe Coursewareable::CollaborationsController do

  let(:classroom) { Fabricate('coursewareable/classroom') }

  describe 'DELETE destroy' do
    let(:collaboration) do
      Fabricate('coursewareable/collaboration', :classroom => classroom)
    end

    before(:each) do
      @request.host = "#{classroom.slug}.#{@request.host}"
      delete(:destroy, :id => collaboration.id, :use_route => :coursewareable)
    end

    context 'not being logged in' do
      it { should redirect_to(login_path) }
    end
  end

  describe 'GET index' do
    before(:each) do
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:index, :use_route => :coursewareable)
    end

    context 'not being logged in' do
      it { should redirect_to(login_path) }
    end
  end

  describe 'POST create' do
    let(:email) { '' }
    before(:each) do
      @request.host = "#{classroom.slug}.#{@request.host}"
      post(:create, :email => email, :use_route => :coursewareable)
    end

    context 'not being logged in' do
      it { should redirect_to(login_path) }
    end
  end

end
