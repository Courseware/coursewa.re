require 'spec_helper'

describe MembershipMailer do

  describe '#new_member_email' do
    let(:membership) { Fabricate('coursewareable/membership') }
    let(:mail) { MembershipMailer.new_member_email(membership) }

    subject { mail }

    its(:subject) { should match(membership.classroom.title) }
    its(:to) { should eq([membership.user.email]) }
    its(:from) { should eq([Courseware.config.default_email_address]) }
    its('body.encoded') { should match(membership.user.name) }
    its('body.encoded') { should match(membership.classroom.title) }
    its('body.encoded') { should match(membership.classroom.slug) }
  end

  describe '#new_invitation_email' do
    let(:invitation) { Fabricate(:membership_invitation) }
    let(:mail) { MembershipMailer.new_invitation_email(invitation) }

    subject { mail }

    its(:subject) { should match(invitation.classroom.title) }
    its(:to) { should eq([invitation.email]) }
    its(:from) { should eq([Courseware.config.default_email_address]) }
    its('body.encoded') { should match(invitation.creator.name) }
    its('body.encoded') { should match(invitation.classroom.title) }
    its('body.encoded') { should match(invitation.classroom.slug) }
  end

end
