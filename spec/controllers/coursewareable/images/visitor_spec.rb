require 'spec_helper'

describe Coursewareable::ImagesController do
  include ActionDispatch::TestProcess

  let(:classroom) { Fabricate('coursewareable/classroom') }

  describe 'GET index' do
    before do
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:index, :use_route => :coursewareable)
    end

    context 'not being logged in' do
      it { should redirect_to(login_path) }
    end
  end

  describe 'POST create' do
    before do
      @request.host = "#{classroom.slug}.#{@request.host}"
      post(:create, :use_route => :coursewareable)
    end

    context 'not being logged in' do
      it { should redirect_to(login_path) }
    end
  end

  describe 'DELETE :destroy' do
    before do
      @request.host = "#{classroom.slug}.#{@request.host}"
      delete(:destroy, :use_route => :coursewareable)
    end

    context 'not being logged in' do
      it { should redirect_to(login_path) }
    end
  end

end
