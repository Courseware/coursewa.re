# Mailer to handle [Coursewareable::Classroom] announcement emails
class AnnouncementMailer < ActionMailer::Base
  default from: Courseware.config.default_email_address
  layout 'email'

  # Sends an email to classroom members when a new announcement is posted
  #
  # @param [PublicActivity::Activity] announcement, the announcement object
  def new_announcement_email(announcement)
    @announcement = announcement
    @classroom = announcement.recipient
    @members = @classroom.members - [@classroom.owner]

    # Do not try to send this if the only member is the owner
    return if @members.empty?

    subject = _('A new announcement was posted in %s classroom') % [
      @classroom.title
    ]
    @members.each do |member|
      @member = member
      # Find email settings for current user
      settings = member.memberships.where(
        :classroom_id => @classroom.id
      ).first
      if settings.send_announcements
        mail(:to => member.email, :subject => subject)
      end
    end
  end
end
