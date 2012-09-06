require 'spec_helper'
require 'cancan/matchers'

describe User do
  describe 'abilities' do
    subject { ability }
    let(:ability){ Ability.new(user) }

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

  end
end
