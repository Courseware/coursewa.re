require 'spec_helper'

describe Classroom do

  it { should validate_presence_of(:title) }
  it { should ensure_length_of(:title).is_at_least(4).is_at_most(32) }
  it { should validate_presence_of(:slug) }
  it { should validate_presence_of(:description) }

  it { should belong_to(:user) }

  Courseware.config.domain_blacklist.each do |domain|
    it { should_not allow_value(domain).for(:title) }
  end

  describe 'with all attributes' do
    subject{ Fabricate(:classroom) }

    it { should validate_uniqueness_of(:title) }
    it { should respond_to(:slug) }

    its(:user) { should be_a(User) }
    its(:slug) { should match(/^[\w\-0-9]+$/) }
  end

end
