require 'spec_helper'

describe Coursewareable::FilesController do

  let(:classroom) { Fabricate('coursewareable/classroom') }

  describe 'GET index' do
    context 'http request' do
      before do
        @request.host = "#{classroom.slug}.#{@request.host}"
        get(:index, :use_route => :coursewareable)
      end

      context 'not being logged in' do
        it { should redirect_to(login_path) }
      end
    end

    context 'xhr request' do
      before do
        @request.host = "#{classroom.slug}.#{@request.host}"
        xhr(:get, :index, :use_route => :coursewareable)
      end

      context 'not being logged in' do
        it { should redirect_to(login_path) }
      end
    end
  end

  describe 'DELETE destroy' do
    let(:upload) { Fabricate('coursewareable/upload', :classroom => classroom,
                             :user => classroom.owner) }

    before do
      @request.host = "#{classroom.slug}.#{@request.host}"
      delete(:destroy, :id => upload.id, :use_route => :coursewareable)
    end

    context 'not being logged in' do
      it { should redirect_to(login_path) }
    end
  end

end
