Fabricator(:user) do
  email       { sequence(:email) { Faker::Internet.email } }
  first_name  Faker::Name.first_name
  last_name   Faker::Name.last_name
  password    'secret'
end

Fabricator(:admin, :from => :user) do
  role        :admin
end

Fabricator(:confirmed_user, :from => :user) do
  after_create { |usr| usr.activate! }
end
