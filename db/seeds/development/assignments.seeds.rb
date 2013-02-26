after 'development:lectures' do
  email = '%s@coursewa.re' % (ENV['USER'] || 'dev')
  me = Coursewareable::User.find_by_email(email)
  my_classroom = me.classrooms.first

  my_classroom.lectures.limit(2).each do |lecture|
    Fabricate('coursewareable/assignment', :classroom => my_classroom,
              :user => me, :lecture => lecture)
  end

  my_classroom.lectures.offset(2).limit(2).each do |lecture|
    Fabricate(:assignment_with_quiz, :classroom => my_classroom,
              :user => me, :lecture => lecture)
  end
end
