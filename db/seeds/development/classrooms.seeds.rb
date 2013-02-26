after 'development:users' do
  email = '%s@coursewa.re' % (ENV['USER'] || 'dev')
  me = Coursewareable::User.find_by_email(email)
  someone = Coursewareable::User.last

  2.times {
    Fabricate('coursewareable/classroom', :owner => me)
  }

  Fabricate('coursewareable/classroom', :owner => someone)
end
