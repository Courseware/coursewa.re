after 'development:classrooms' do
  email = '%s@coursewa.re' % (ENV['USER'] || 'dev')
  me = Coursewareable::User.find_by_email(email)
  my_classroom = me.classrooms.first

  5.times {
    Fabricate('coursewareable/lecture', :classroom => my_classroom,
              :user => me)
  }
end
