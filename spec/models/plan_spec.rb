require 'spec_helper'

describe Plan do
  let(:plan){ Fabricate(:user).plan }

  it { should belong_to(:user) }

  Courseware.config.plans.keys do |plan|
    it { should allow_value(plan).for(:slug) }
  end

  describe 'with all attributes' do
    subject{ Fabricate(:plan) }
    its(:user) { should be_a(User) }
  end

end
