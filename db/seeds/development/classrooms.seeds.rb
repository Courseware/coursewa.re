after 'development:users' do
  me = Coursewareable::User.find_by_email('stas@nerd.ro')
  someone = Coursewareable::User.last

  2.times {
    Fabricate('coursewareable/classroom', :owner => me)
  }

  Fabricate('coursewareable/classroom', :owner => someone)
end
