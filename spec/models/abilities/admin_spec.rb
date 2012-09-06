require 'spec_helper'
require 'cancan/matchers'

describe User do
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
  end
end
