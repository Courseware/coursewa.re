require 'spec_helper'

describe Coursewareable::ImagesController do
  include ActionDispatch::TestProcess

  let(:classroom) { Fabricate('coursewareable/classroom') }

  describe 'GET index' do

    context 'not being logged in' do
      it 'should redirect to login' do
        @request.host = "#{classroom.slug}.#{@request.host}"
        get :index, :use_route => :coursewareable
        response.should redirect_to(login_path)
      end

      it 'should redirect to login if classroom does not exist' do
        @request.host = "wrong.#{@request.host}"
        get :index, :use_route => :coursewareable
        response.should redirect_to(login_path)
      end
    end

    context 'being logged in' do
      it 'should respond with a json' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "#{classroom.slug}.#{@request.host}"
        get :index, :use_route => :coursewareable
        response.body.strip.should be_empty
      end

      it 'should redirect to not found if classroom does not exist' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "missing.#{@request.host}"
        get :index, :use_route => :coursewareable
        response.should redirect_to('/404')
      end
    end

  end

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

      it 'should create the image' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "#{classroom.slug}.#{@request.host}"

        post :create, { :use_route => :coursewareable,
          :file => fixture_file_upload('/test.png', 'image/png'),
          :assetable_type => syllabus.class.name,
          :assetable_id => syllabus.id
        }
        json = JSON.parse(response.body)

        json['filelink'].should eq(classroom.images.first.url(:large))
        json['filename'].should eq(classroom.images.first.description)
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
      let(:image) {
        Fabricate('coursewareable/image',
          :classroom => classroom, :user => classroom.owner)
      }

      it 'should destroy the image' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "#{classroom.slug}.#{@request.host}"
        delete :destroy, :use_route => :coursewareable, :id => image.id
        response.should redirect_to(images_url)
      end

      it 'should do nothing if image is missing' do
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
