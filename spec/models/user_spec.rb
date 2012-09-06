require 'spec_helper'
require 'cancan/matchers'

describe User do

  it { should validate_presence_of(:password) }
  it { should ensure_length_of(:password).is_at_least(6).is_at_most(32) }

  it { should validate_presence_of(:email) }
  it { should validate_format_of(:email).with('stas+cw@nerd.ro') }

  it { should have_one(:plan) }
  it { should have_many(:memberships).dependent(:destroy) }
  it { should have_many(:collaborations).dependent(:destroy) }
  it { should have_many(:classrooms).through(:memberships) }
  it { should have_many(:created_classrooms).dependent(:destroy) }
  it { should have_many(:images) }
  it { should have_many(:uploads) }
  it { should have_many(:lectures) }
  it { should have_many(:assignments) }
  it { should have_many(:responses) }

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
    subject { ability }
    let(:ability){ Ability.new(user) }

    describe 'for admin' do
      let(:user){ Fabricate(:admin) }

      it{ should be_able_to(:create, User) }
      it{ should be_able_to(:create, Classroom) }
      it{ should be_able_to(:create, Image) }
      it{ should be_able_to(:create, Upload) }
      it{ should be_able_to(:create, Lecture) }
      it{ should be_able_to(:create, Membership) }
      it{ should be_able_to(:create, Collaboration) }
      it{ should be_able_to(:create, Syllabus) }
      it{ should be_able_to(:create, Assignment) }
      it{ should be_able_to(:manage, Fabricate(:membership)) }
      it{ should be_able_to(:manage, Fabricate(:collaboration)) }
      it{ should be_able_to(:manage, Fabricate(:classroom)) }
      it{ should be_able_to(:manage, Fabricate(:user)) }
      it{ should be_able_to(:manage, Fabricate(:image)) }
      it{ should be_able_to(:manage, Fabricate(:upload)) }
      it{ should be_able_to(:manage, Fabricate(:lecture)) }
      it{ should be_able_to(:manage, Fabricate(:syllabus)) }
      it{ should be_able_to(:manage, Fabricate(:assignment)) }
    end

    describe 'for visitor' do
      let(:user){ User.new }

      it{ should be_able_to(:create, User) }
      it{ should_not be_able_to(:manage, Fabricate(:user)) }

      it{ should_not be_able_to(:create, Classroom) }
      it{ should_not be_able_to(:manage, Fabricate(:classroom)) }
      it{ should_not be_able_to(:dashboard, Fabricate(:classroom)) }

      it{ should_not be_able_to(:create, Membership) }
      it{ should_not be_able_to(:create, Collaboration) }
      it{ should_not be_able_to(:destroy, Fabricate(:membership)) }
      it{ should_not be_able_to(:destroy, Fabricate(:collaboration)) }

      it{ should_not be_able_to(:create, Image) }
      it{ should_not be_able_to(:create, Upload) }
      it{ should_not be_able_to(:manage, Fabricate(:image)) }
      it{ should_not be_able_to(:manage, Fabricate(:upload)) }
    end

    describe 'for user' do
      let(:user){ Fabricate(:confirmed_user) }

      it{ should_not be_able_to(:create, User) }
      it{ should_not be_able_to(:manage, Fabricate(:user)) }
      it{ should be_able_to(:manage, user) }

      it{ should be_able_to(:create, Classroom) }
      it{ should_not be_able_to(:update, Fabricate(:classroom)) }
      it{ should_not be_able_to(:destroy, Fabricate(:classroom)) }
      it{ should_not be_able_to(:dashboard, Fabricate(:classroom)) }
      it{ should be_able_to(:update, Fabricate(:classroom, :owner => user)) }
      it{ should be_able_to(:destroy, Fabricate(:classroom, :owner => user)) }
      it{ should be_able_to(:dashboard, Fabricate(:classroom, :owner => user))}

      it{ should_not be_able_to(:create, Fabricate.build(:membership)) }
      it{ should_not be_able_to(:create, Collaboration) }
      it{ should_not be_able_to(:destroy, Fabricate(:membership)) }
      it{ should_not be_able_to(:destroy, Fabricate(:collaboration)) }

      it{ should be_able_to(:create, Image) }
      it{ should be_able_to(:create, Upload) }
      it{ should_not be_able_to(:manage, Fabricate(:image)) }
      it{ should_not be_able_to(:manage, Fabricate(:upload)) }
      it{ should be_able_to(:manage, Fabricate(:image, :user => user)) }
      it{ should be_able_to(:manage, Fabricate(:upload, :user => user)) }

      context 'with plan limits reached' do
        let(:user){ Fabricate(:classroom).owner.reload }
        it{ should_not be_able_to(:create, Classroom ) }
      end

      context 'with plan allowing collaborators' do
        before{ user.plan.increment!(:allowed_collaborators)}
        it{ should be_able_to(:create, Collaboration) }
      end
    end

    describe 'for classroom owner' do
      let(:classroom){ Fabricate(:classroom) }
      let(:user){ classroom.owner.reload }

      context 'members' do
        it{ should be_able_to(:create, Fabricate.build(
          :membership, :classroom => classroom, :user => Fabricate(:user))) }
        it{ should be_able_to(:destroy, Fabricate(:membership,
                                                  :classroom => classroom))}
      end

      context 'collaborators' do
        before{ user.plan.increment!(:allowed_collaborators)}

        it{ should be_able_to(:create, Fabricate.build(
          :collaboration, :classroom => classroom, :user => Fabricate(:user))) }
        it{ should be_able_to(:destroy, Fabricate(:collaboration,
                                                  :classroom => classroom))}
      end

      context 'lectures' do
        it{ should be_able_to(:create, Fabricate.build(
          :lecture, :user => user, :classroom => classroom))
        }
        it{ should be_able_to(:manage, Fabricate(
          :lecture, :user => user, :classroom => classroom)) }
      end

      context 'syllabuses' do
        it{ should be_able_to(:create, Fabricate.build(
          :syllabus, :user => user, :classroom => classroom))
        }
        it{ should be_able_to(:manage, Fabricate(
          :syllabus, :user => user, :classroom => classroom)) }
      end

      context 'assignments' do
        it{ should be_able_to(:create, Fabricate.build(
          :assignment, :user => user, :classroom => classroom))
        }
        it{ should be_able_to(:manage, Fabricate(
          :assignment, :user => user, :classroom => classroom)) }
      end
    end

    describe 'for classroom lecture' do
      let(:lecture){ Fabricate(:lecture) }

      context 'and a visitor' do
        let(:user){ User.new }

        it{ should_not be_able_to(:create, Fabricate.build(
          :lecture, :user => user, :classroom => lecture.classroom))
        }
        it{ should_not be_able_to(:manage, lecture) }
        it{ should_not be_able_to(:show, lecture) }
        it{ should_not be_able_to(:index, lecture) }
      end

      context 'and a member' do
        let(:user){ Fabricate(:user) }
        before do
          classroom = lecture.classroom
          classroom.members << user
          classroom.save
        end

        it{ should_not be_able_to(:create, Fabricate.build(
          :lecture, :user => user, :classroom => lecture.classroom))
        }
        it{ should_not be_able_to(:manage, lecture) }
        it{ should be_able_to(:show, lecture) }
        it{ should be_able_to(:index, lecture) }
      end

      context 'and a collaborator' do
        let(:user){ Fabricate(:user) }
        before do
          classroom = lecture.classroom
          classroom.collaborators << user
          classroom.save
        end

        it{ should be_able_to(:create, Fabricate.build(
          :lecture, :user => user, :classroom => lecture.classroom))
        }
        it{ should be_able_to(:manage, lecture) }
      end

      context 'and a non-member' do
        let(:user){ Fabricate(:user) }

        it{ should_not be_able_to(:create, Fabricate.build(
          :lecture, :user => user, :classroom => lecture.classroom))
        }
        it{ should_not be_able_to(:manage, lecture) }
        it{ should_not be_able_to(:show, lecture) }
        it{ should_not be_able_to(:index, lecture) }
      end
    end

    describe 'for classroom syllabus' do
      let(:syllabus){ Fabricate(:syllabus) }

      context 'and a visitor' do
        let(:user){ User.new }

        it{ should_not be_able_to(:create, Fabricate.build(
          :syllabus, :user => user, :classroom => syllabus.classroom))
        }
        it{ should_not be_able_to(:manage, syllabus) }
        it{ should_not be_able_to(:show, syllabus) }
      end

      context 'and a member' do
        let(:user){ Fabricate(:user) }
        before do
          classroom = syllabus.classroom
          classroom.members << user
          classroom.save
        end

        it{ should_not be_able_to(:create, Fabricate.build(
          :syllabus, :user => user, :classroom => syllabus.classroom))
        }
        it{ should_not be_able_to(:manage, syllabus) }
        it{ should be_able_to(:show, syllabus) }
      end

      context 'and a collaborator' do
        let(:user){ Fabricate(:user) }
        before do
          classroom = syllabus.classroom
          classroom.collaborators << user
          classroom.save
        end

        it{ should be_able_to(:create, Fabricate.build(
          :syllabus, :user => user, :classroom => syllabus.classroom))
        }
        it{ should be_able_to(:manage, syllabus) }
      end

      context 'and a non-member' do
        let(:user){ Fabricate(:user) }

        it{ should_not be_able_to(:create, Fabricate.build(
          :syllabus, :user => user, :classroom => syllabus.classroom))
        }
        it{ should_not be_able_to(:manage, syllabus) }
        it{ should_not be_able_to(:show, syllabus) }
      end
    end

    describe 'for classroom assignment' do
      let(:assignment){ Fabricate(:assignment) }

      context 'and a visitor' do
        let(:user){ User.new }

        it{ should_not be_able_to(:create, Fabricate.build(
          :assignment, :user => user, :classroom => assignment.classroom))
        }
        it{ should_not be_able_to(:manage, assignment) }
        it{ should_not be_able_to(:show, assignment) }
      end

      context 'and a member' do
        let(:user){ Fabricate(:user) }
        before do
          classroom = assignment.classroom
          classroom.members << user
          classroom.save
        end

        it{ should_not be_able_to(:create, Fabricate.build(
          :assignment, :user => user, :classroom => assignment.classroom))
        }
        it{ should_not be_able_to(:manage, assignment) }
        it{ should be_able_to(:show, assignment) }
      end

      context 'and a collaborator' do
        let(:user){ Fabricate(:user) }
        before do
          classroom = assignment.classroom
          classroom.collaborators << user
          classroom.save
        end

        it{ should be_able_to(:create, Fabricate.build(
          :assignment, :user => user, :classroom => assignment.classroom))
        }
        it{ should be_able_to(:manage, assignment) }
      end

      context 'and a non-member' do
        let(:user){ Fabricate(:user) }

        it{ should_not be_able_to(:create, Fabricate.build(
          :assignment, :user => user, :classroom => assignment.classroom))
        }
        it{ should_not be_able_to(:manage, assignment) }
        it{ should_not be_able_to(:show, assignment) }
      end
    end

    describe 'for classroom response' do
      let(:response){ Fabricate(:response) }

      context 'and a visitor' do
        let(:user){ User.new }

        it{ should_not be_able_to(:create, Fabricate.build(
          :response, :user => user, :classroom => response.classroom))
        }
        it{ should_not be_able_to(:manage, response) }
        it{ should_not be_able_to(:show, response) }
      end

      context 'and a member' do
        let(:user){ Fabricate(:user) }
        let(:member_response){ Fabricate.build(
          :response, :user => user, :classroom => response.classroom)
        }
        before do
          classroom = response.classroom
          classroom.members << user
          classroom.save
        end

        it{ should be_able_to(:create, Fabricate.build(
          :response, :user => user, :classroom => response.classroom))
        }
        it{ should_not be_able_to(:destroy, member_response) }
        it{ should be_able_to(:show, member_response) }

        context 'not owning response' do
          let(:user){ Fabricate(:user) }
          before do
            classroom = response.classroom
            classroom.members << user
            classroom.save
          end

          it{ should_not be_able_to(:show, response) }
        end
      end

      context 'and a collaborator' do
        let(:user){ Fabricate(:user) }
        before do
          classroom = response.classroom
          classroom.collaborators << user
          classroom.save
        end

        it{ should_not be_able_to(:create, Fabricate.build(
          :response, :user => user, :classroom => response.classroom))
        }
        it{ should be_able_to(:destroy, response) }
        it{ should be_able_to(:show, response) }
      end

      context 'and a non-member' do
        let(:user){ Fabricate(:user) }

        it{ should_not be_able_to(:create, Fabricate.build(
          :response, :user => user, :classroom => response.classroom))
        }
        it{ should_not be_able_to(:destroy, response) }
        it{ should_not be_able_to(:show, response) }
      end
    end

  end
end
