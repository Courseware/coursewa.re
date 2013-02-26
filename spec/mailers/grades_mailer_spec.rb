require 'spec_helper'

describe GradesMailer do
  let(:grade) { Fabricate('coursewareable/grade') }

  describe '#new_grade_email' do
    let(:mail) { GradesMailer.new_grade_email(grade) }

    it 'should be valid' do
      mail.subject.should match(grade.user.name)
      mail.should deliver_from(Courseware.config.default_email_address)
      mail.should deliver_to(grade.receiver)
      mail.body.encoded.should match(grade.assignment.title)
      mail.body.encoded.should match(grade.comment.split("\n").first)
    end
  end

  describe '#update_grade_email' do
    let(:mail) { GradesMailer.update_grade_email(grade) }

    it 'should be valid' do
      mail.subject.should match(grade.user.name)
      mail.should deliver_from(Courseware.config.default_email_address)
      mail.should deliver_to(grade.receiver)
      mail.body.encoded.should match(grade.assignment.title)
      mail.body.encoded.should match(grade.comment.split("\n").first)
    end
  end
end
