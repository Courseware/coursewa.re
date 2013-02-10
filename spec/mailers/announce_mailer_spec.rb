require "spec_helper"

describe AnnounceMailer do
  let(:membership) { Fabricate('coursewareable/membership') }
  let(:announcement) do
    {:key => "announcement.create", :recipient => membership.classroom,
    :parameters => { :content => "Announcement", 
                    :user_name => membership.classroom.owner.name}}
  end

  describe "#new_announce_email" do
    let(:mail) {AnnounceMailer.new_announce_email(announcement, membership.user)}
    it "should be valid" do
        mail.should have_subject("New announcement in #{membership.classroom.title}")
        mail.should deliver_to(membership.user.email)
        mail.should deliver_from(Courseware.config.default_email_address)
        mail.body.encoded.should match(announcement[:parameters][:content])
    end
  end
end
