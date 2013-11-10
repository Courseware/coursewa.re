require 'spec_helper'

describe Coursewareable::UsersController do

  describe 'GET new' do
    before{ get(:new, :use_route => :coursewareable) }

    context 'not logged in' do
      it { should render_template(:new) }
    end

    context 'when logged in' do
      before(:all) do
        setup_controller_request_and_response
        @controller.send(:auto_login, Fabricate('coursewareable/user'))
      end

      it { should redirect_to(root_path) }
    end
  end

  describe 'POST create' do
    let(:user_attr) { Fabricate.build(:confirmed_user) }

    before(:each) do
      @old_emails_count = ActionMailer::Base.deliveries.count
      @old_users_count = Coursewareable::User.count

      post(:create, :use_route => :coursewareable, :user => {
        :email => user_attr.email, :password => user_attr.password,
        :password_confirmation => user_attr.password
      })
    end

    shared_examples 'creates no new users' do
      it { Coursewareable::User.count.should eq(@old_users_count) }
      it { ActionMailer::Base.deliveries.count.should eq(@old_emails_count) }
    end

    it 'creates the user' do
      Coursewareable::User.count.should eq(@old_users_count + 1)
      ActionMailer::Base.deliveries.count.should eq(@old_emails_count + 1)
      should redirect_to(login_path)
    end

    context 'missing required params' do
      let(:user_attr) do
        Fabricate.build(:confirmed_user, :email => nil, :password => nil,
                        :password_confirmation => nil)
      end

      it { should render_template(:new) }
      include_examples 'creates no new users'
    end

    context 'when logged in' do
      before(:all) do
        setup_controller_request_and_response
        @controller.send(:auto_login, Fabricate('coursewareable/user'))
      end

      it { should redirect_to(login_path) }
      it { ActionMailer::Base.deliveries.count.should eq(@old_emails_count) }
      it { Coursewareable::User.count.should eq(@old_users_count) }
    end
  end

  describe 'GET activate' do
    let(:user) { Fabricate('coursewareable/user') }

    before do
      get(:activate, :use_route => :coursewareable,
          :id => user.activation_token)
      user.reload
    end

    subject { user }

    its(:activation_state) { should eq('active') }
    its('activities_as_owner.last.key') {
      should eq('coursewareable_user.create') }
    it { should redirect_to(login_path) }
  end

  describe 'GET me' do
    let(:user){ Fabricate(:confirmed_user) }

    before do
      @controller.send(:auto_login, user)
      get(:me, :use_route => :coursewareable)
    end

    it { should render_template(:me) }
  end

  describe 'GET my_account' do
    let(:user){ Fabricate(:confirmed_user) }

    before do
      @controller.send(:auto_login, user)
      get(:my_account, :use_route => :coursewareable)
    end

    it { should render_template(:my_account) }
  end

  describe 'GET invite' do
    before{ get(:invite, :use_route => :coursewareable) }

    context 'not logged in' do
      it { should redirect_to(login_path) }
    end

    context 'when logged in' do
      before(:all) do
        setup_controller_request_and_response
        @controller.send(:auto_login, Fabricate('coursewareable/user'))
      end

      it { should render_template(:invite) }
    end
  end

  describe 'POST send_invitation' do
    let(:user_attr) { Fabricate.build(:confirmed_user) }
    let(:email) { Faker::Internet.email }

    before(:each) do
      @old_emails_count = ActionMailer::Base.deliveries.count
      post(:send_invitation, :use_route => :coursewareable, :email => email,
          :message => Faker::Lorem.paragraph)
    end

    context 'when not logged in' do
      it { should redirect_to(login_path) }
      it { ActionMailer::Base.deliveries.count.should eq(@old_emails_count) }
    end

    context 'when logged in' do
      before(:all) do
        setup_controller_request_and_response
        @controller.send(:auto_login, Fabricate('coursewareable/user'))
      end

      it { should redirect_to(invite_users_path) }
      it { ActionMailer::Base.deliveries.count.should eq(@old_emails_count + 1)}

      context 'when email is blank' do
        let(:email) { '' }
        it { ActionMailer::Base.deliveries.count.should eq(@old_emails_count) }
      end
    end
  end

  describe 'GET notifications' do
    before do
      get(:notifications, :use_route => :coursewareable)
    end

    context 'when logged in' do
      before(:all) do
        setup_controller_request_and_response
        @controller.send(:auto_login, Fabricate('coursewareable/user'))
      end

      it { should render_template(:notification) }
    end

    context 'when not logged in' do
      it { should redirect_to(login_path) }
    end
  end

  describe 'PUT notifications' do
    let(:classroom) { Fabricate('coursewareable/classroom') }
    let(:association) { classroom.owner.associations.first }

    before do
      put(:update_notifications, :use_route => :coursewareable, :user => {
        :associations_attributes => {
          '0' => {
            'send_grades' => '0',
            'send_announcements' => '1',
            'send_generic' => '1',
            'id' => association.id
          }
        }
      } )
    end

    context 'when logged in' do
      before(:all) do
        setup_controller_request_and_response
        @controller.send(:auto_login, classroom.owner)
      end

      it 'should change email notification settings' do
        association.reload
        association.send_grades.should eq('0')
        association.send_announcements.should eq('1')
        association.send_generic.should eq('1')
        should redirect_to(notifications_users_path)
      end
    end

    context 'when not logged in' do
      it { should redirect_to(login_path) }
    end
  end

  describe 'GET request_deletion' do
    let(:user) { Fabricate(:confirmed_user) }
    before do
      get(:request_deletion, :use_route => :coursewareable)
    end

    context 'when logged in' do
      before(:all) do
        setup_controller_request_and_response
        @controller.send(:auto_login, user)
      end

      it { should render_template(:request_deletion) }
    end

    context 'when not logged in' do
      it { should redirect_to(login_path) }
    end
  end

  describe 'POST request_deletion' do
    let(:user) { Fabricate(:confirmed_user) }

    context 'when logged in' do
      before(:each) do
        setup_controller_request_and_response
        @controller.send(:auto_login, user)
        @old_emails_count = ActionMailer::Base.deliveries.count
      end

      it 'should send an email and redirect to dashboard' do
        post(:request_deletion, :use_route => :coursewareable,
          :message => Faker::Lorem.paragraph)

        (ActionMailer::Base.deliveries.count - @old_emails_count).should eq(1)
        user.reload.id.should eq(user.id)
        response.should redirect_to(dashboard_home_path)
        flash.now[:success].should eq('Your request was sent.')
      end

      it 'should print an error if message field is empty and redirect back' do
        post(:request_deletion, :use_route => :coursewareable)

        ActionMailer::Base.deliveries.count.should eq(@old_emails_count)
        user.reload.id.should eq(user.id)
        flash.now[:alert].should eq('Please fill the field!')
        response.should redirect_to(request_deletion_users_path)
      end
    end

    context 'when not logged in' do
      before do
        post(:request_deletion, :use_route => :coursewareable,
          :message => Faker::Lorem.paragraph)
      end

      it { should redirect_to(login_path) }
    end
  end
end
