require "spec_helper"

describe GradesMailer do
  let(:grade) { Fabricate('coursewareable/grade') }
  describe "#new_grade_email" do
    let(:mail) { GradesMailer.new_grade_email(grade) }
    
    it "should be valid" do
      mail.should have_subject("#{grade.user.name} graded you!")
      mail.should deliver_from(Courseware.config.default_email_address)
      mail.should deliver_to(grade.receiver)
      mail.body.encoded.should match(grade.assignment.title)
      mail.body.encoded.should match(grade.assignment.lecture.title)
      mail.body.encoded.should match(grade.mark.to_s)
    end
  end

  describe "#update_grade_email" do
    let(:mail) { GradesMailer.update_grade_email(grade) }

    it "should be valid" do
      mail.should have_subject("#{grade.user.name} modified your grade!")
      mail.should deliver_from(Courseware.config.default_email_address)
      mail.should deliver_to(grade.receiver)
      mail.body.encoded.should match(grade.assignment.title)
      mail.body.encoded.should match(grade.assignment.lecture.title)
      mail.body.encoded.should match(grade.mark.to_s)
    end
  end
end
