after 'development:classrooms' do
  me = Coursewareable::User.find_by_email('stas@nerd.ro')
  my_classroom = me.classrooms.first

  my_classroom.members << Coursewareable::User.find(me.id + 1)
  my_classroom.members << Coursewareable::User.find(me.id + 2)
end
