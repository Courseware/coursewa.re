require 'spec_helper'
require 'cancan/matchers'

describe User do
  describe 'abilities' do
    subject { ability }
    let(:ability){ Ability.new(user) }

    describe 'for classroom' do
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

  end
end
