require 'spec_helper'
require 'cancan/matchers'

describe User do
  describe 'abilities' do
    subject { ability }
    let(:ability){ Ability.new(user) }

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
