class AnnouncementMailer < ActionMailer::Base
  default from: Courseware.config.default_email_address
  layout 'email'

  # Sends an email to classroom members when a new announcement is posted
  #
  # @param [PublicActivity::Activity] announcement, the announcement object
  def new_announcement_email(announcement)
    classroom = announcement.recipient
    subject = _('A new announcement was posted in %s classroom') % [
      classroom.title
    ]

    classroom.members.each do |member|
      next if member.email == classroom.owner.email

      @announcement = announcement
      @user = member
      mail(:to => member.email, :subject => subject)
    end
  end
end
