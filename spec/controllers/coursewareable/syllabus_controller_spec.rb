require 'spec_helper'

describe Coursewareable::SyllabusesController do

  let(:classroom) { Fabricate('coursewareable/classroom') }

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
      it 'should show the syllabus' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "#{classroom.slug}.#{@request.host}"
        post :create, :use_route => :coursewareable
        response.should render_template(:show)
      end

      it 'should create the syllabus' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "#{classroom.slug}.#{@request.host}"

        post :create, :use_route => :coursewareable, :syllabus => {
          :title => Faker::Lorem.sentence,
          :content => Faker::HTMLIpsum.body,
          :intro => Faker::Lorem.paragraph
        }

        classroom.syllabus.should_not be_nil
        response.should render_template(:show)
      end

      it 'should not create the syllabus if exists' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "#{classroom.slug}.#{@request.host}"
        title = Faker::Lorem.sentence
        syllabus = Fabricate('coursewareable/syllabus',
          :classroom => classroom, :user => classroom.owner)
        syllabus_count = Coursewareable::Syllabus.count

        post :create, :use_route => :coursewareable, :syllabus => {
          :title => Faker::Lorem.sentence,
          :content => Faker::HTMLIpsum.body,
          :intro => Faker::Lorem.paragraph
        }

        syllabus_count.should eq(Coursewareable::Syllabus.count)
        classroom.syllabus.title.should eql(syllabus.title)
        response.should render_template(:show)
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
      it 'should show the syllabus' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "#{classroom.slug}.#{@request.host}"
        put :update, :use_route => :coursewareable
        response.should render_template(:show)
      end

      it 'should update the syllabus' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "#{classroom.slug}.#{@request.host}"
        title = Faker::Lorem.sentence
        syllabus = Fabricate('coursewareable/syllabus',
          :classroom => classroom, :user => classroom.owner)

        put :update, :use_route => :coursewareable, :syllabus => {
          :title => title }

        classroom.syllabus.title.should eql(title)
        response.should render_template(:show)
      end

      it 'should do nothing if syllabus is missing' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "#{classroom.slug}.#{@request.host}"
        title = Faker::Lorem.sentence

        put(:update, :use_route => :coursewareable,
          :syllabus => { :title => title })

        classroom.syllabus.should be_nil
        response.should render_template(:show)
      end

      it 'should redirect to not found if classroom does not exist' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "missing.#{@request.host}"
        put :update, :use_route => :coursewareable
        response.should redirect_to('/404')
      end
    end

  end

end
