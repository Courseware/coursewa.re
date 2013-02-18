after 'development:classrooms' do
  email = '%s@coursewa.re' % (ENV['USER'] || 'dev')
  me = Coursewareable::User.find_by_email(email)
  my_classroom = me.classrooms.first

  my_classroom.collaborators << Coursewareable::User.find(me.id + 3)
  my_classroom.collaborators << Coursewareable::User.find(me.id + 4)
end
