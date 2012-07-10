require 'spec_helper'

describe User do

  it { should validate_presence_of(:password) }
  it { should ensure_length_of(:password).is_at_least(6).is_at_most(32) }

  it { should validate_presence_of(:email) }

  it { should validate_presence_of(:username) }
  it { should_not allow_mass_assignment_of(:username) }
  it { should ensure_length_of(:username).is_at_least(1).is_at_most(32) }
  it { should validate_format_of(:username).not_with('.')}
  it { should validate_format_of(:username).not_with('_')}

  describe 'usernames black list' do
    Courseware.config.domain_blacklist.each do |subdomain|
      it "should include #{subdomain}" do
        lambda{ Fabricate(:user, :username => subdomain) }.should raise_error
      end
    end
  end

  describe 'object' do
    subject{ Fabricate(:user) }

    it { should validate_uniqueness_of(:username) }
    it { should validate_uniqueness_of(:email) }

    its(:name) { should match(/\w?+ \w?+/) }
  end
end
