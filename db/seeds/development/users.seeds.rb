load Rails.root.join('spec','support','fabrication.rb')

# Main user
Fabricate(:confirmed_user, :email => 'stas@nerd.ro',
          :plan => Fabricate('coursewareable/plan', :plan => :micro))

# Dummy users
5.times {
  Fabricate(:confirmed_user)
}
