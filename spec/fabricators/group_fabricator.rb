Fabricator(:group) do
  title       Faker::Education.school[0..31]
  description Faker::Lorem.sentence
  user
end
