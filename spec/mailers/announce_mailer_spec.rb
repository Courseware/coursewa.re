require "spec_helper"

describe AnnounceMailer do
  let(:membership) { Fabricate('coursewareable/membership') }
  let(:announcement) do
    {:key => "announcement.create", :recipient => membership.classroom,
    :parameters => { :content => "Announcement", 
                    :user_name => membership.classroom.owner.name}}
  end

  describe "#new_announce_email" do
    let(:mail) {AnnounceMailer.delay.new_announce_email(announcement)}
    it "should be valid" do
        mail.should have_subject("New announcement in #{membership.classroom.title}")
    end
  end
end
