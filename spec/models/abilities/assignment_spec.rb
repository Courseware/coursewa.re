require 'spec_helper'
require 'cancan/matchers'

describe User do
  describe 'abilities' do
    subject { ability }
    let(:ability){ Ability.new(user) }

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

  end
end
