require 'spec_helper'

describe Coursewareable::CollaborationsController do

  let(:classroom) { Fabricate('coursewareable/classroom') }

  describe 'GET index' do
    before(:each) do
      @request.host = "#{classroom.slug}.#{@request.host}"
      get(:index, :use_route => :coursewareable)
    end

    context 'being logged in as a owner' do
      before(:all) do
        setup_controller_request_and_response
        @controller.send(:auto_login, classroom.owner)
      end

      it { should render_template(:index) }
    end
  end

  describe 'POST create' do
    let(:existing_user) { Fabricate(:confirmed_user) }
    let(:email) { existing_user.email }

    before(:each) do
      @controller.send(:auto_login, classroom.owner)
      @request.host = "#{classroom.slug}.#{@request.host}"
      post(:create, :email => email, :use_route => :coursewareable)
    end

    context 'being logged in as an owner' do
      it do
        classroom.collaborators.map(&:email).should_not include(email)
        should redirect_to(collaborations_path)
      end

      context 'with plan limits allowed to add a collaborator' do
        before(:all){ classroom.owner.plan.increment!(:allowed_collaborators) }

        it do
          classroom.collaborators.map(&:email).should include(email)
          should redirect_to(collaborations_path)
        end
      end

      context 'with plan limits allowing a collaborator and invalid email' do
        before(:all){ classroom.owner.plan.increment!(:allowed_collaborators) }
        let(:email) { Faker::Internet.email }

        it do
          classroom.collaborators.map(&:email).should_not include(email)
          should redirect_to(collaborations_path)
        end
      end
    end
  end

  describe 'DELETE destroy' do
    let(:collaboration) do
      Fabricate('coursewareable/collaboration', :classroom => classroom)
    end

    before(:each) do
      @request.host = "#{classroom.slug}.#{@request.host}"
      delete(:destroy, :id => collaboration.id,
             :use_route => :coursewareable)
    end

    context 'being logged in as a owner' do
      before(:all) do
        setup_controller_request_and_response
        @controller.send(:auto_login, classroom.owner)
      end

      it { should redirect_to(collaborations_path) }
      it { classroom.collaborations.should be_empty }
    end
  end

end
