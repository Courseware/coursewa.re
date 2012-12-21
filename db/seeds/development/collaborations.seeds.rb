after 'development:classrooms' do
  me = Coursewareable::User.find_by_email('stas@nerd.ro')
  my_classroom = me.classrooms.first

  my_classroom.collaborators << Coursewareable::User.find(me.id + 3)
  my_classroom.collaborators << Coursewareable::User.find(me.id + 4)
end
