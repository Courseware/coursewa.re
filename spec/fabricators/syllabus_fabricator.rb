Fabricator(:syllabus) do
  title     { sequence(:lecture_title){ Faker::Lorem.sentence } }
  content   Faker::HTMLIpsum.body
  intro     Faker::Lorem.paragraph
  user
  classroom
end
