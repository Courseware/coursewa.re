class GradesMailer < ActionMailer::Base
  default from: Courseware.config.default_email_address
  layout 'email'

  # Sends an email to user when he gets a grade
  #
  # @param [Hash] params with details about grade
  def new_grade_email(grade)
    @grade = grade
    @assignment_url = coursewareable.lecture_assignment_url(
      grade.assignment.lecture, grade.assignment
    )

    subject = "One of your responses was graded by #{@grade.user.name}"
    mail(:to => grade.receiver.email, :subject => subject)
  end

  # Sends an email to user when he's grade is updated
  #
  # @param [Hash] params with details about grade
  def update_grade_email(grade)
    @grade = grade
    @assignment_url = coursewareable.lecture_assignment_url(
      grade.assignment.lecture, grade.assignment
    )

    subject = "One of your assignment grades was updated by #{@grade.user.name}"
    mail(:to => grade.receiver.email, :subject => subject )
  end
end
