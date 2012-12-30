require 'spec_helper'

describe Coursewareable::ResponsesController do

  let(:member) { Fabricate(:confirmed_user) }
  let(:assignment) { Fabricate('coursewareable/assignment') }
  let(:classroom) { assignment.classroom }
  let(:lecture) { assignment.lecture }

  before { classroom.members << member }

  describe 'GET new' do
    context 'not a member for this classroom' do
      let(:assignment_two) { Fabricate('coursewareable/assignment') }

      before do
        @request.host = "#{assignment_two.classroom.slug}.#{@request.host}"
        @controller.send(:auto_login, member)
        get(:new, :lecture_id => assignment_two.lecture.slug,
            :assignment_id => assignment_two.slug,
            :use_route => :coursewareable)
      end

      it { should redirect_to(login_path) }
      its('flash.keys') { should include(:alert) }
    end

    context 'being logged in as a member' do
      before(:each) do
        @controller.send(:auto_login, member)
        @request.host = "#{classroom.slug}.#{@request.host}"
      end

      context 'where classroom, lecture and assignment exists' do
        before do
          get(:new, :lecture_id => lecture.slug,
              :assignment_id => assignment.slug, :use_route => :coursewareable)
        end

        it { should render_template(:new) }
      end
    end
  end

  describe 'POST create' do
    context 'not a member for this classroom' do
      let(:assignment_two) { Fabricate('coursewareable/assignment') }

      before do
        @request.host = "#{assignment_two.classroom.slug}.#{@request.host}"
        @controller.send(:auto_login, member)
        post(:create, :lecture_id => assignment_two.lecture.slug,
            :assignment_id => assignment_two.slug,
            :use_route => :coursewareable)
      end

      it { should redirect_to(login_path) }
      its('flash.keys') { should include(:alert) }
    end

    context 'being logged in as member' do
      before(:each) do
        @controller.send(:auto_login, member)
        @request.host = "#{classroom.slug}.#{@request.host}"
      end

      context 'where classroom, lecture and assignment exists' do
        let(:resp) { assignment.responses.reload.first }
        let(:quiz) { Fabricate.build(:assignment_with_quiz).quiz }
        let(:answers) { Faker::Lorem.word }

        before do
          post(:create, :lecture_id => lecture.slug,
              :assignment_id => assignment.slug,
              :use_route => :coursewareable,
              :response => { :content => Faker::HTMLIpsum.body,
                             :answers => answers} )
        end

        it do
          resp.answers.should be_nil
          should redirect_to(
            lecture_assignment_response_path(:lecture_id => lecture.slug,
              :assignment_id => assignment.slug, :id => resp.id) )
        end

        context 'when assignment has a quiz' do
          let(:answers) do
            {'0' => {'options' => {
              '0' => {'answer' => quiz[0][:options][0][:content] } } } }
          end
          before(:all) do
            assignment.update_attribute(:quiz, quiz)
          end

        it do
          resp.answers.should_not be_nil
          resp.stats.should eq({:all => 4, :wrong => 3})
          resp.coverage.should eq(25.0)
          should redirect_to(
            lecture_assignment_response_path(:lecture_id => lecture.slug,
              :assignment_id => assignment.slug, :id => resp.id) )
        end

        end
      end
    end
  end

  describe 'GET show' do
    let(:resp) do
      Fabricate('coursewareable/response', :classroom => classroom,
                :assignment => assignment, :user => member)
    end

    context 'not a member for this classroom' do
      let(:resp_two) { Fabricate('coursewareable/response') }

      before do
        @request.host = "#{resp_two.classroom.slug}.#{@request.host}"
        @controller.send(:auto_login, member)
        get(:show, :lecture_id => resp_two.assignment.lecture.slug,
            :assignment_id => resp_two.assignment.slug,
            :id => resp_two.id,
            :use_route => :coursewareable)
      end

      it { should redirect_to(login_path) }
      its('flash.keys') { should include(:alert) }
    end

    context 'being logged in as a member' do
      before(:each) do
        @controller.send(:auto_login, member)
        @request.host = "#{classroom.slug}.#{@request.host}"
      end

      context 'where classroom, lecture and assignment exists' do
        before do
          get(:show, :lecture_id => lecture.slug,
              :assignment_id => assignment.slug,
              :id => resp.id,
              :use_route => :coursewareable)
        end

        it { should render_template(:show) }

        context 'response is not owned' do
          let(:resp) do
            Fabricate('coursewareable/response', :classroom => classroom,
                      :assignment => assignment)
          end

          it { should redirect_to(login_path) }
          its('flash.keys') { should include(:alert) }
        end
      end
    end
  end

  describe 'DELETE destroy' do
    let(:resp) do
      Fabricate('coursewareable/response', :classroom => classroom,
                :assignment => assignment, :user => member)
    end

    context 'not being a member for this classroom' do
      let(:resp_two) { Fabricate('coursewareable/response') }

      before do
        @request.host = "#{resp_two.classroom.slug}.#{@request.host}"
        @controller.send(:auto_login, member)
        delete(:destroy, :lecture_id => resp_two.assignment.lecture.slug,
            :assignment_id => resp_two.assignment.slug,
            :id => resp_two.id,
            :use_route => :coursewareable)
      end

      it { should redirect_to(login_path) }
      its('flash.keys') { should include(:alert) }
    end

    context 'being logged in as a member' do
      before(:each) do
        @controller.send(:auto_login, member)
        @request.host = "#{classroom.slug}.#{@request.host}"
      end

      context 'where classroom, lecture and assignment exists' do
        before do
        delete(:destroy, :lecture_id => lecture.slug,
            :assignment_id => assignment.slug,
            :id => resp.id,
            :use_route => :coursewareable)
        end

        it { should redirect_to(login_path) }
        its('flash.keys') { should include(:alert) }
      end
    end
  end
end
