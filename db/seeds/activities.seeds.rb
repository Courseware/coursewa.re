email = '%s@coursewa.re' % (ENV['USER'] || 'dev')
me = Coursewareable::User.find_by_email(email)
my_classroom = me.classrooms.first

activity_key = 'announcement.create'
500.times do
  ts = Time.at(0.0 + rand * (Time.now.to_f - 0.0))
  announcement = me.activities_as_owner.create(
    :key => activity_key, :recipient => my_classroom, :parameters => {
      :content => Faker::Lorem.sentence, :user_name => me.name}
  )
  announcement.update_attribute(:created_at, ts)
end
