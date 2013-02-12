class GradesMailer < ActionMailer::Base
  default from: Courseware.config.default_email_address
  layout 'email'

  # Send email to user when a grade is created
  #
  # param [Hash] params with details about grade
  def new_grade_email(grade)
    @grade_user = grade.user
    @content = grade
    @date = Time.now
    mail(:to => grade.receiver.email, 
          :subject => "#{@grade_user.name} graded you!")
  end

  def update_grade_email(grade)
    @grade_user = grade.user
    @content = grade
    @date = Time.now
    mail(:to => grade.receiver.email, 
          :subject => "#{@grade_user.name} modified your grade!")
  end
end
