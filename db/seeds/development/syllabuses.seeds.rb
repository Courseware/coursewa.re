after 'development:classrooms' do
  me = Coursewareable::User.find_by_email('stas@nerd.ro')
  my_classroom = me.classrooms.first

  Fabricate('coursewareable/syllabus', :classroom => my_classroom, :user => me)
end
