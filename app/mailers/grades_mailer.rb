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
    # Find email settings for current user
    settings = grade.receiver.memberships.where(
      :classroom_id => grade.classroom.id
    ).first
    if settings.send_grades
      subject = _("One of your responses was graded by %s") % [
        @grade.user.name
      ]
      mail(:to => grade.receiver.email, :subject => subject)
    end
  end

  # Sends an email to user when he's grade is updated
  #
  # @param [Hash] params with details about grade
  def update_grade_email(grade)
    @grade = grade
    @assignment_url = coursewareable.lecture_assignment_url(
      grade.assignment.lecture, grade.assignment
    )
    # Find email settings for current user
    settings = grade.receiver.memberships.where(
      :classroom_id => grade.classroom.id
    ).first
    if settings.send_grades
      subject = _("One of your assignment grades was updated by %s") % [
        @grade.user.name
      ]
      mail(:to => grade.receiver.email, :subject => subject )
    end
  end
end
