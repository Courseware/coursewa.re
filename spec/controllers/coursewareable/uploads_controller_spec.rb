require 'spec_helper'

describe Coursewareable::UploadsController do

  include ActionDispatch::TestProcess

  let(:classroom) { Fabricate('coursewareable/classroom') }

  describe 'POST create' do

    context 'not being logged in' do
      it 'should redirect to login' do
        @request.host = "#{classroom.slug}.#{@request.host}"
        post :create, :use_route => :coursewareable
        response.should redirect_to(login_path)
      end

      it 'should redirect to login if classroom does not exist' do
        @request.host = "wrong.#{@request.host}"
        post :create, :use_route => :coursewareable
        response.should redirect_to(login_path)
      end
    end

    context 'being logged in' do

      let(:syllabus) {
        Fabricate('coursewareable/syllabus',
          :user => classroom.owner, :classroom => classroom)
      }

      it 'should create the upload' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "#{classroom.slug}.#{@request.host}"

        post :create, { :use_route => :coursewareable,
          :file => fixture_file_upload('/test.txt', 'text/plain'),
          :assetable_type => syllabus.class.name,
          :assetable_id => syllabus.id
        }
        json = JSON.parse(response.body)

        json['filelink'].should eq(classroom.uploads.first.url)
        json['filename'].should eq(classroom.uploads.first.description)
      end

      it 'should redirect to not found if classroom does not exist' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "missing.#{@request.host}"
        post :create, :use_route => :coursewareable
        response.should redirect_to('/404')
      end
    end

  end

  describe 'DELETE :destroy' do

    context 'not being logged in' do
      it 'should redirect to login' do
        @request.host = "#{classroom.slug}.#{@request.host}"
        delete :destroy, :use_route => :coursewareable
        response.should redirect_to(login_path)
      end

      it 'should redirect to login if classroom does not exist' do
        @request.host = "wrong.#{@request.host}"
        delete :destroy, :use_route => :coursewareable
        response.should redirect_to(login_path)
      end
    end

    context 'being logged in' do
      let(:upload) {
        Fabricate('coursewareable/upload',
          :classroom => classroom, :user => classroom.owner)
      }

      it 'should destroy the upload' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "#{classroom.slug}.#{@request.host}"
        delete :destroy, :use_route => :coursewareable, :id => upload.id
        response.should redirect_to(uploads_url)
      end

      it 'should do nothing if upload is missing' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "#{classroom.slug}.#{@request.host}"

        delete :destroy, :use_route => :coursewareable

        response.should redirect_to('/404')
      end

      it 'should redirect to not found if classroom does not exist' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "missing.#{@request.host}"
        delete :destroy, :use_route => :coursewareable
        response.should redirect_to('/404')
      end
    end

  end

end
