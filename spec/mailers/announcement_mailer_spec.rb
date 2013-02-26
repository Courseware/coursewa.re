require 'spec_helper'

describe AnnouncementMailer do
  let(:membership) { Fabricate('coursewareable/membership') }
  let(:announcement) { Fabricate.build(
    :announcement, :recipient => membership.classroom) }

  describe '#new_announce_email' do
    let(:mail) { AnnouncementMailer.new_announcement_email(announcement) }

    it 'should be valid' do
      mail.subject.should match(membership.classroom.title)
      mail.should deliver_to(membership.user.email)
      mail.should deliver_from(Courseware.config.default_email_address)
      mail.body.encoded.should match(announcement.parameters[:content])
    end
  end
end
