class AnnounceMailer < ActionMailer::Base
  default from: Courseware.config.default_email_address
  layout 'email'

  # Send email to users from classroom when is posted a new announcement
  #
  # param [Hash] announcement, with email address and details
  def new_announce_email(announcement)
      announcement[:recipient].members.each do |user|
        # Find the settings
        email_notif = user.memberships.find_by_classroom_id(
          announcement[:recipient].id).email_announcement
        unless user.email == announcement[:recipient].owner.email and
          email_notif[:send_announcements]

          @announcement = announcement
          @user = user
          mail(:to => user.email,
              :subject => _("New announcement in %s") % announcement[:recipient][:title])
        end
      end
  end
end
