require 'spec_helper'

describe Coursewareable::ClassroomsController do

  let(:classroom) { Fabricate('coursewareable/classroom') }

  describe 'GET dashboard' do
    before do
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:dashboard, :use_route => :coursewareable)
    end

    context 'not being logged in' do
      it { should redirect_to(login_path) }
    end
  end

  describe 'GET new' do
    before do
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:new, :use_route => :coursewareable)
    end

    context 'not being logged in' do
      it { should redirect_to(login_path) }
    end
  end

  describe 'POST :create' do
    before do
      @request.host = "#{classroom.slug}.#{@request.host}"
      post(:create, :use_route => :coursewareable)
    end

    context 'not being logged in' do
      it { should redirect_to(login_path) }
    end
  end

  describe 'GET edit' do
    before do
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:edit, :use_route => :coursewareable)
    end

    context 'not being logged in' do
      it { should redirect_to(login_path) }
    end
  end

  describe 'PUT update' do
    before do
      @request.host = "#{classroom.slug}.#{@request.host}"
      put(:update, :use_route => :coursewareable)
    end

    context 'not being logged in' do
      it { should redirect_to(login_path) }
    end
  end

end

