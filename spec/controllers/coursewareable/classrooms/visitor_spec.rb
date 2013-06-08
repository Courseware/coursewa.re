require 'spec_helper'

describe Coursewareable::ClassroomsController do

  let(:classroom) { Fabricate('coursewareable/classroom') }

  describe 'GET dashboard' do
    context 'http request' do
      before do
        @request.host = "#{classroom.slug}.#{@request.host}"
        get(:dashboard, :use_route => :coursewareable)
      end

      context 'not being logged in' do
        it { should redirect_to(login_path) }
      end
    end

    context 'xhr request' do
      before do
        @request.host = "#{classroom.slug}.#{@request.host}"
        xhr(:get, :dashboard, :use_route => :coursewareable)
      end

      context 'not being logged in' do
        it { should redirect_to(login_path) }
      end
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

  describe 'GET staff' do
    before do
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:staff, :use_route => :coursewareable)
    end

    context 'not being logged in' do
      it { should redirect_to(login_path) }
    end
  end

  describe 'GET stats' do
    let(:format) { :html }
    before do
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:stats, :use_route => :coursewareable, :format => format)
    end

    context 'not being logged in' do
      it { should redirect_to(login_path) }

      context 'format is json' do
        let(:format) { :json }
        it { should redirect_to(login_path) }
      end
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

  describe 'POST announce' do
    let(:attrs) { Fabricate.build('coursewareable/classroom') }

    before do
      @request.host = "#{classroom.slug}.#{@request.host}"
      post(:announce, :use_route => :coursewareable,
           :announcement => attrs.description)
    end

    context 'not being logged in' do
      it { should redirect_to(login_path) }
    end
  end

end
