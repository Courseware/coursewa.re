# Mailer to handle [Coursewareable::Grade] emails
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

    receiver = grade.receiver
    subject = _('One of your responses was graded by %s') % grade.user.name
    opt = receiver.memberships.where(:classroom_id => grade.classroom.id).first

    mail(:to => receiver.email, :subject => subject) if opt.send_grades
  end

  # Sends an email to user when he's grade is updated
  #
  # @param [Hash] params with details about grade
  def update_grade_email(grade)
    @grade = grade
    @assignment_url = coursewareable.lecture_assignment_url(
      grade.assignment.lecture, grade.assignment
    )

    receiver = grade.receiver
    opt = receiver.memberships.where(:classroom_id => grade.classroom.id).first
    subject = _('%s updated one of your assignment grades') % grade.user.name

    mail(:to => receiver.email, :subject => subject ) if opt.send_grades
  end
end
