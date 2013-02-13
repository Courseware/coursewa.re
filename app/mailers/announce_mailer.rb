class AnnounceMailer < ActionMailer::Base
  default from: Courseware.config.default_email_address
  layout 'email'
  
  # Send email to users from classroom when is posted a new announcement
  #
  # param [Hash] announcement, with email address and details
  def new_announce_email(announcement)
    unless announcement[:recipient].nil?
      announcement[:recipient].members.each do |user|
        unless user.email == announcement[:recipient].owner.email
          @announcement = announcement
          @user = user
          mail(:to => user.email,
              :subject => _("New announcement in %s") % announcement[:recipient][:title])
        end
      end
    end
  end
end
