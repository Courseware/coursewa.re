Fabricator(:user) do
  username  { Faker::Internet.user_name }
  email     { |attrs| "#{attrs[:username]}@#{Courseware.config.domain_name}" }
  first_name { Faker::Name.first_name }
  last_name { Faker::Name.last_name }
  password  { 'secret' }
end
