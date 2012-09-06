Fabricator(:assignment) do
  title         { sequence(:lecture_title){ Faker::Lorem.sentence } }
  content       Faker::HTMLIpsum.body
  user
  classroom     { |attr| Fabricate(:classroom, :owner => attr[:user]) }
  lecture       { |attr| Fabricate(
    :lecture, :user => attr[:user], :classroom => attr[:classroom]) }
end
