require 'spec_helper'

describe MembershipMailer do
  let(:membership) { Fabricate('coursewareable/membership') }

  describe '#new_member_email' do
    let(:mail) { MembershipMailer.new_member_email(membership) }

    subject { mail }

    its(:subject) { should match(membership.classroom.title) }
    its(:to) { should eq([membership.user.email]) }
    its(:from) { should eq([Courseware.config.default_email_address]) }
    its('body.encoded') { should match(membership.user.name) }
    its('body.encoded') { should match(membership.classroom.title) }
    its('body.encoded') { should match(membership.classroom.slug) }
  end

end
