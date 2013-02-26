load Rails.root.join('spec','support','fabrication.rb')

# Main user
email = '%s@coursewa.re' % (ENV['USER'] || 'dev')
plan = Fabricate('coursewareable/plan', :plan => :micro)
Fabricate(:confirmed_user, :email => email, :plan => plan)

# Dummy users
5.times {
  Fabricate(:confirmed_user)
}
