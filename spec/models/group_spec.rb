require 'spec_helper'

describe Group do

  it { should validate_presence_of(:title) }
  it { should ensure_length_of(:title).is_at_least(4).is_at_most(32) }
  it { should validate_presence_of(:slug) }
  it { should validate_presence_of(:description) }

  Courseware.config.domain_blacklist.each do |domain|
    it { should_not allow_value(domain).for(:title) }
  end

  describe 'with all attributes' do
    subject{ Fabricate(:group) }

    it { should validate_uniqueness_of(:title) }
    it { should respond_to(:slug) }

    it { should belong_to(:user) }

    its(:user) { should be_a(User) }
    its(:slug) { should match(/^[\w\-0-9]+$/) }
  end

end
