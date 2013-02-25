require 'spec_helper'

describe CollaborationMailer do
  let(:collaboration) { Fabricate('coursewareable/membership') }

  describe '#new_member_email' do
    let(:mail) { CollaborationMailer.new_collaboration_email(collaboration) }

    subject { mail }

    its(:subject) { should match(collaboration.classroom.title) }
    its(:to) { should eq([collaboration.user.email]) }
    its(:from) { should eq([Courseware.config.default_email_address]) }
    its('body.encoded') { should match(collaboration.user.name) }
    its('body.encoded') { should match(collaboration.classroom.title) }
    its('body.encoded') { should match(collaboration.classroom.slug) }
  end

  describe '#new_invitation_email' do
    let(:invitation) { Fabricate(:collaborator_invitation) }
    let(:mail) { CollaborationMailer.new_invitation_email(invitation) }

    subject { mail }

    its(:subject) { should match(invitation.classroom.title) }
    its(:to) { should eq([invitation.email]) }
    its(:from) { should eq([Courseware.config.default_email_address]) }
    its('body.encoded') { should match(invitation.creator.name) }
    its('body.encoded') { should match(invitation.classroom.title) }
    its('body.encoded') { should match(invitation.classroom.slug) }
  end

end
