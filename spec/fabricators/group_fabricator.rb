Fabricator(:group) do
  title       Faker::Education.school
  description Faker::Lorem.sentence
  user
end
