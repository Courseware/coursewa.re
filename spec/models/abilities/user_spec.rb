require 'spec_helper'
require 'cancan/matchers'

describe User do
  describe 'abilities' do
    subject { ability }
    let(:ability){ Ability.new(user) }

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

      context 'with plan limits reached' do
        let(:user){ Fabricate(:classroom).owner.reload }
        it{ should_not be_able_to(:create, Classroom ) }
      end

      context 'with plan allowing collaborators' do
        before{ user.plan.increment!(:allowed_collaborators)}
        it{ should be_able_to(:create, Collaboration) }
      end

    end
  end

end
