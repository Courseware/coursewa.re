after 'development:responses', 'development:memberships' do
  me = Coursewareable::User.find_by_email('stas@nerd.ro')
  my_classroom = me.classrooms.first
  members = my_classroom.members - [me]

  assignment = my_classroom.assignments.first
  Fabricate('coursewareable/grade', :classroom => my_classroom, :user => me,
            :assignment => assignment, :receiver_id => members.first.id)

  assignment = my_classroom.assignments.last
  Fabricate('coursewareable/grade', :classroom => my_classroom, :user => me,
            :assignment => assignment, :receiver_id => members.last.id,
            :response_id => my_classroom.responses.where(
              :user_id => members.last.id).first.id)
end

