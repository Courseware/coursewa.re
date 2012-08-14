Fabricator(:classroom) do
  title       Faker::Education.school[0..31]
  description Faker::Lorem.sentence
  owner(:fabricator => :user)

  after_build { |classroom| classroom.owner.activate! }
end
