require 'spec_helper'
require 'cancan/matchers'

describe User do
  describe 'abilities' do
    subject { ability }
    let(:ability){ Ability.new(user) }

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
  end
end
