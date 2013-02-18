after 'development:assignments', 'development:memberships' do
  email = '%s@coursewa.re' % (ENV['USER'] || 'dev')
  me = Coursewareable::User.find_by_email(email)
  my_classroom = me.classrooms.first
  members = my_classroom.members - [me]

  assignment = my_classroom.assignments.offset(2).last
  Fabricate('coursewareable/response', :classroom => my_classroom,
            :user => members.first, :assignment => assignment) do

    answers { assignment.quiz }
  end

  assignment = my_classroom.assignments.offset(2).first
  Fabricate('coursewareable/response', :classroom => my_classroom,
            :user => members.last, :assignment => assignment) do
    answers {
      answ = assignment.quiz
      answ[0]['options'][0]['content'] = 'WRONG ANSWER'
      answ[0]['options'][0]['wrong'] = true

      answ[1]['options'][0]['wrong'] = true

      answ[2]['options'][0]['wrong'] = true
      answ
    }
  end

end
