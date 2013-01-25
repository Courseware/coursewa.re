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

end
