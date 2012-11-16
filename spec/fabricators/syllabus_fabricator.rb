Fabricator(:syllabus) do
  title     { sequence(:syllabus_title){ Faker::Lorem.sentence } }
  content   Faker::HTMLIpsum.body
  intro     Faker::Lorem.paragraph
  user
  classroom
end
