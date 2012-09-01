Fabricator(:course) do
  title         { sequence(:course_title){ Faker::Lorem.sentence } }
  content       Faker::HTMLIpsum.body
  requisite     Faker::Lorem.paragraph
  user
  classroom     { |attr| Fabricate(:classroom, :owner => attr[:user]) }
end
