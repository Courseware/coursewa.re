require 'spec_helper'
require 'cancan/matchers'

describe User do
  describe 'abilities' do
    subject { ability }
    let(:ability){ Ability.new(user) }

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

  end
end
