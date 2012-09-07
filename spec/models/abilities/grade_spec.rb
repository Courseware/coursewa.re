require 'spec_helper'
require 'cancan/matchers'

describe User do
  describe 'abilities' do
    subject { ability }
    let(:ability){ Ability.new(user) }

    describe 'for classroom grade' do
      let(:grade){ Fabricate(:grade) }

      context 'and a visitor' do
        let(:user){ User.new }

        it{ should_not be_able_to(:create, Fabricate.build(
          :grade, :user => user, :classroom => grade.classroom))
        }
        it{ should_not be_able_to(:manage, grade) }
        it{ should_not be_able_to(:index, grade) }
      end

      context 'and a member' do
        let(:user){ Fabricate(:user) }
        before do
          classroom = grade.classroom
          classroom.members << user
          classroom.save
        end

        it{ should_not be_able_to(:create, Fabricate.build(
          :grade, :user => user, :classroom => grade.classroom))
        }
        it{ should_not be_able_to(:manage, grade) }
        it{ should_not be_able_to(:index, grade) }
      end

      context 'and a collaborator' do
        let(:user){ Fabricate(:user) }
        before do
          classroom = grade.classroom
          classroom.collaborators << user
          classroom.save
        end

        it{ should be_able_to(:create, Fabricate.build(
          :grade, :user => user, :classroom => grade.classroom))
        }
        it{ should be_able_to(:manage, grade) }
        it{ should be_able_to(:index, grade) }
      end

      context 'and a non-member' do
        let(:user){ Fabricate(:user) }

        it{ should_not be_able_to(:create, Fabricate.build(
          :grade, :user => user, :classroom => grade.classroom))
        }
        it{ should_not be_able_to(:manage, grade) }
        it{ should_not be_able_to(:index, grade) }
      end
    end

  end
end
