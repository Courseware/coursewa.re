class AnnounceMailer < ActionMailer::Base
  default from: Courseware.config.default_email_address
  layout 'email'
  
  # Send email to users from classroom when is posted a new announcement
  #
  # param [Hash] announcement, with email address and details
  def new_announce_email(announcement, user)
    @announcement = announcement
    @user = user
    mail(:to => user.email,
        :subject => "New announcement in #{announcement[:recipient][:title]}")
  end
end
