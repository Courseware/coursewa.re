require 'spec_helper'

describe Coursewareable::AssignmentsController do

  let(:lecture) { Fabricate('coursewareable/lecture') }
  let(:classroom) { lecture.classroom }
  let(:quiz_data) do
    [ {
      :options => [{
        :valid => true,
        :content => "Correct"
      }, {
        :valid => false,
        :content => "Wrong"
      }],
      :content => "Radio Question Title",
      :type => "radios"
    } ]
  end

  describe 'GET new' do
    context 'not being logged in' do
      it 'should redirect to login' do
        @request.host = "#{classroom.slug}.#{@request.host}"
        get :new, :lecture_id => lecture.slug, :use_route => :coursewareable
        response.should redirect_to(login_path)
      end

      it 'should redirect to login if classroom does not exist' do
        @request.host = "wrong.#{@request.host}"
        get :new, :use_route => :coursewareable
        response.should redirect_to(login_path)
      end
    end

    context 'being logged in' do
      it 'should show creation screen' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "#{classroom.slug}.#{@request.host}"

        get :new, :lecture_id => lecture.slug, :use_route => :coursewareable
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

    let(:assignment) { Fabricate('coursewareable/assignment',
      :lecture => lecture, :classroom => classroom, :user => classroom.owner) }

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

        get(:show, :lecture_id => lecture.slug,
            :assignment_id => assignment.slug, :use_route => :coursewareable)
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

    let(:assignment) { Fabricate('coursewareable/assignment',
      :lecture => lecture, :classroom => classroom, :user => classroom.owner) }

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

        get(:edit, :lecture_id => lecture.slug,
            :assignment_id => assignment.slug, :use_route => :coursewareable)
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
        post :create, :lecture_id => lecture.id, :use_route => :coursewareable
        response.should redirect_to(login_path)
      end
    end

    context 'being logged in' do
      it 'should create the lecture' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "#{classroom.slug}.#{@request.host}"

        post(:create, :lecture_id => lecture.slug,
          :use_route => :coursewareable,
          :has_quiz => true,
          :assignment => {
            :title => Faker::Lorem.sentence,
            :content => Faker::HTMLIpsum.body,
            :quiz => quiz_data }
        )

        lecture.assignments.should_not be_empty
        response.should redirect_to(edit_lecture_assignment_url(lecture,
          lecture.assignments.first, :subdomain => classroom.slug))
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

    let!(:assignment) { Fabricate('coursewareable/assignment',
      :lecture => lecture, :classroom => classroom, :user => classroom.owner) }

    context 'not being logged in' do
      it 'should redirect to login' do
        @request.host = "#{classroom.slug}.#{@request.host}"
        put :update, :use_route => :coursewareable
        response.should redirect_to(login_path)
      end

      it 'should redirect to login if classroom does not exist' do
        @request.host = "wrong.#{@request.host}"
        put :update, :lecture_id => lecture.slug, :use_route => :coursewareable
        response.should redirect_to(login_path)
      end
    end

    context 'being logged in' do

      context 'and assignment has quiz data' do
        before do
          assignment.update_attribute(:quiz, quiz_data)
        end

        it 'should remove quiz data' do
          @controller.send(:auto_login, classroom.owner)
          @request.host = "#{classroom.slug}.#{@request.host}"

          get(:update, :lecture_id => lecture.slug, :id => assignment.slug,
              :use_route => :coursewareable)

          assignment.reload.quiz.should be_nil
        end
      end

      it 'should update the lecture' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "#{classroom.slug}.#{@request.host}"
        title = Faker::Lorem.sentence

        put :update, :use_route => :coursewareable, :lecture_id => lecture.slug,
          :assignment => { :title => title }, :id => assignment.slug

        assignment.reload.title.should eql(title)
        response.should redirect_to(edit_lecture_assignment_url(lecture,
          assignment, :subdomain => classroom.slug))
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

    let!(:assignment) { Fabricate('coursewareable/assignment',
      :lecture => lecture, :classroom => classroom, :user => classroom.owner) }

    context 'not being logged in' do
      it 'should redirect to login' do
        @request.host = "#{classroom.slug}.#{@request.host}"
        delete(:destroy, :id => assignment.id, :lecture_id => lecture.slug,
          :use_route => :coursewareable)
        response.should redirect_to(login_path)
      end

      it 'should redirect to login if classroom does not exist' do
        @request.host = "wrong.#{@request.host}"
        delete(:destroy, :id => assignment.id, :lecture_id => lecture.slug,
          :use_route => :coursewareable)
        response.should redirect_to(login_path)
      end
    end

    context 'being logged in' do
      it 'should update the lecture' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "#{classroom.slug}.#{@request.host}"

        delete(:destroy, :id => assignment.id, :lecture_id => lecture.slug,
          :use_route => :coursewareable)

        lecture.assignments.size.should eq(0)
        response.should redirect_to(
          lecture_path(lecture, :subdomain => classroom.slug))
      end

      it 'should redirect to not found if classroom does not exist' do
        @controller.send(:auto_login, classroom.owner)
        @request.host = "missing.#{@request.host}"

        delete(:destroy, :id => assignment.id, :lecture_id => lecture.slug,
          :use_route => :coursewareable)

        response.should redirect_to('/404')
      end
    end

  end

end
