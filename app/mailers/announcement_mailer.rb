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
    associations = @classroom.associations - @classroom.associations.where(
      :user_id => announcement.owner.id)

    # Do not try to send this if the only member is the owner
    return if associations.empty?

    subject = _('An announcement was posted in %s classroom') % @classroom.title
    associations.each do |assoc|
      @member = assoc.user
      # Find email settings for current user
      mail(:to => @member.email,:subject => subject) if assoc.send_announcements
    end
  end
end
