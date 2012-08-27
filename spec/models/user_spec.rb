require 'spec_helper'
require 'cancan/matchers'

describe User do

  it { should validate_presence_of(:password) }
  it { should ensure_length_of(:password).is_at_least(6).is_at_most(32) }
  it { should validate_presence_of(:email) }

  it { should have_one(:plan) }
  it { should have_many(:memberships).dependent(:destroy) }
  it { should have_many(:classrooms).through(:memberships) }
  it { should have_many(:created_classrooms).dependent(:destroy) }

  it { should respond_to(:created_classrooms_count) }
  it { should respond_to(:memberships_count) }

  describe 'with all attributes' do
    subject{ Fabricate(:user) }

    it { should validate_uniqueness_of(:email) }

    its(:role) { should be_nil }
    its(:name) { should match(/\w?+ \w?+/) }
    its(:plan) { should be_a(Plan) }
    its('plan.slug') { should eq(:free) }
  end

  describe 'with no first/last name' do
    subject{ Fabricate(:user, :first_name => nil, :last_name => nil) }
    its(:name) { should match(/^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$/) }
  end

  describe 'with admin role and all attributes' do
    subject{ Fabricate(:admin) }

    its(:role) { should eq(:admin) }
  end

  describe 'abilities' do
    describe 'for admin' do
      subject{ Ability.new( Fabricate(:admin) ) }

      it{ should be_able_to(:create, User) }
      it{ should be_able_to(:create, Classroom) }
      it{ should be_able_to(:manage, Fabricate(:classroom)) }
      it{ should be_able_to(:manage, Fabricate(:user)) }
    end

    describe 'for visitor' do
      subject{ Ability.new( User.new ) }

      it{ should be_able_to(:create, User) }
      it{ should_not be_able_to(:create, Classroom) }
      it{ should_not be_able_to(:manage, Fabricate(:user)) }
      it{ should_not be_able_to(:manage, Fabricate(:classroom)) }
      it{ should_not be_able_to(:dashboard, Fabricate(:classroom)) }
    end

    describe 'for user' do
      let(:user) { Fabricate(:user) }
      subject{ Ability.new( user ) }

      it{ should_not be_able_to(:create, User) }
      it{ should_not be_able_to(:manage, Fabricate(:user)) }
      it{ should be_able_to(:manage, user) }

      it{ should be_able_to(:create, Classroom) }
      it{ should_not be_able_to(:manage, Fabricate(:classroom)) }
      it{ should_not be_able_to(:dashboard, Fabricate(:classroom)) }
      it{ should be_able_to(:manage, Fabricate(:classroom, :owner => user)) }
      it{ should be_able_to(:dashboard, Fabricate(:classroom, :owner => user))}
    end
  end
end
