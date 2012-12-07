require 'spec_helper'

describe Coursewareable::LecturesController do

  let(:classroom) { Fabricate('coursewareable/classroom') }

  describe 'GET new' do
    context 'not being logged in' do
      it 'should redirect to login' do
        @request.host = "#{classroom.slug}.#{@request.host}"
        get :new, :use_route => :coursewareable
        response.should redirect_to(login_path)
      end

      it 'should redirect to login if classroom does not exist' do
        @request.host = "wrong.#{@request.host}"
        get :new, :use_route => :coursewareable
        response.should redirect_to(login_path)
      end
    end

    context 'being logged in' do
      it 'should update the lecture' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "#{classroom.slug}.#{@request.host}"

        get :new, :use_route => :coursewareable
        response.should render_template(:new)
      end

      it 'should redirect to not found if classroom does not exist' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "missing.#{@request.host}"
        get :new, :use_route => :coursewareable
        response.should redirect_to('/404')
      end
    end

  end

  describe 'GET show' do

    context 'not being logged in' do
      it 'should redirect to login' do
        @request.host = "#{classroom.slug}.#{@request.host}"
        get :show, :use_route => :coursewareable
        response.should redirect_to(login_path)
      end

      it 'should redirect to login if classroom does not exist' do
        @request.host = "wrong.#{@request.host}"
        get :show, :use_route => :coursewareable
        response.should redirect_to(login_path)
      end
    end

    context 'being logged in' do
      it 'should render the template' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "#{classroom.slug}.#{@request.host}"
        get :show, :use_route => :coursewareable
        response.should render_template(:show)
      end

      it 'should redirect to not found if classroom does not exist' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "missing.#{@request.host}"
        get :show, :use_route => :coursewareable
        response.should redirect_to('/404')
      end
    end

  end

  describe 'GET edit' do

    context 'not being logged in' do
      it 'should redirect to login' do
        @request.host = "#{classroom.slug}.#{@request.host}"
        get :edit, :use_route => :coursewareable
        response.should redirect_to(login_path)
      end

      it 'should redirect to login if classroom does not exist' do
        @request.host = "wrong.#{@request.host}"
        get :edit, :use_route => :coursewareable
        response.should redirect_to(login_path)
      end
    end

    context 'being logged in' do
      it 'should render the template' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "#{classroom.slug}.#{@request.host}"
        get :edit, :use_route => :coursewareable
        response.should render_template(:edit)
      end

      it 'should redirect to not found if classroom does not exist' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "missing.#{@request.host}"
        get :edit, :use_route => :coursewareable
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
      it 'should create the lecture' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "#{classroom.slug}.#{@request.host}"

        post :create, :use_route => :coursewareable, :lecture => {
          :title => Faker::Lorem.sentence,
          :content => Faker::HTMLIpsum.body,
          :requisite => Faker::Lorem.paragraph
        }

        classroom.lectures.should_not be_empty
        response.should redirect_to(edit_lecture_url(classroom.lectures.first))
      end

      it 'should redirect to not found if classroom does not exist' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "missing.#{@request.host}"
        post :create, :use_route => :coursewareable
        response.should redirect_to('/404')
      end
    end

  end

  describe 'PUT update' do

    context 'not being logged in' do
      it 'should redirect to login' do
        @request.host = "#{classroom.slug}.#{@request.host}"
        put :update, :use_route => :coursewareable
        response.should redirect_to(login_path)
      end

      it 'should redirect to login if classroom does not exist' do
        @request.host = "wrong.#{@request.host}"
        put :update, :use_route => :coursewareable
        response.should redirect_to(login_path)
      end
    end

    context 'being logged in' do
      it 'should update the lecture' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "#{classroom.slug}.#{@request.host}"
        title = Faker::Lorem.sentence
        lecture = Fabricate('coursewareable/lecture',
          :classroom => classroom, :user => classroom.owner)

        put :update, :use_route => :coursewareable, :id => lecture.id,
          :lecture => { :title => title }

        lecture.reload.title.should eql(title)
        response.should redirect_to(edit_lecture_url(lecture))
      end

      it 'should redirect to not found if classroom does not exist' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "missing.#{@request.host}"
        put :update, :use_route => :coursewareable
        response.should redirect_to('/404')
      end
    end

  end

  describe 'DELETE destroy' do
    let(:lecture) {
      Fabricate('coursewareable/lecture', :classroom => classroom,
        :user => classroom.owner)
    }

    context 'not being logged in' do
      it 'should redirect to login' do
        @request.host = "#{classroom.slug}.#{@request.host}"
        put :destroy, :id => lecture.id, :use_route => :coursewareable
        response.should redirect_to(login_path)
      end

      it 'should redirect to login if classroom does not exist' do
        @request.host = "wrong.#{@request.host}"
        put :destroy, :id => lecture.id, :use_route => :coursewareable
        response.should redirect_to(login_path)
      end
    end

    context 'being logged in' do
      it 'should update the lecture' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "#{classroom.slug}.#{@request.host}"

        put :destroy, :id => lecture.id, :use_route => :coursewareable

        classroom.lectures.size.should eq(0)
        response.should redirect_to(syllabus_url)
      end

      it 'should redirect to not found if classroom does not exist' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "missing.#{@request.host}"
        put :destroy, :id => lecture.id, :use_route => :coursewareable

        response.should redirect_to('/404')
      end
    end

  end
end
