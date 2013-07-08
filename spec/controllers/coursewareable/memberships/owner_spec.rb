require 'spec_helper'

describe Coursewareable::MembershipsController do

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
      before(:all) do
        MembershipMailer.stub(:delay).and_return(MembershipMailer)
        MembershipMailer.should_receive(:new_member_email)
      end

      it do
        classroom.members.map(&:email).should include(email)
        should redirect_to(memberships_path)
      end

      context 'and using an unregistered email' do
        let(:email) { Faker::Internet.email }
        before(:all) do
          MembershipMailer.stub(:delay).and_return(MembershipMailer)
          MembershipMailer.should_not_receive(:new_member_email)
          MembershipMailer.should_receive(:new_invitation_email)
        end

        it do
          classroom.collaborators.map(&:email).should_not include(email)
          classroom.invitations.map(&:email).should include(email)
          should redirect_to(memberships_path)
        end
      end
    end
  end

  describe 'DELETE destroy' do
    let(:membership) do
      Fabricate('coursewareable/membership', :classroom => classroom)
    end

    before(:each) do
      @controller.send(:auto_login, owner)
      @request.host = "#{classroom.slug}.#{@request.host}"
      delete(:destroy, :id => membership.id, :use_route => :coursewareable)
    end

    context 'being logged in as a owner' do
      let(:owner) { classroom.owner }

      it { should redirect_to(memberships_path) }
      it { classroom.memberships.should be_empty }
    end
  end
end
