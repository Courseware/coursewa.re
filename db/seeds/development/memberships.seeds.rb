after 'development:classrooms' do
  email = '%s@coursewa.re' % (ENV['USER'] || 'dev')
  me = Coursewareable::User.find_by_email(email)
  my_classroom = me.classrooms.first

  my_classroom.members << Coursewareable::User.find(me.id + 1)
  my_classroom.members << Coursewareable::User.find(me.id + 2)
end
