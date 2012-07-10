Fabricator(:user) do
  # Remove special chars to help faker a bit with the username
  username  { Faker::Internet.user_name.gsub(/[\.\_]/, '-') }
  email     { |attrs| "#{attrs[:username]}@#{Courseware.config.domain_name}" }
  first_name { Faker::Name.first_name }
  last_name { Faker::Name.last_name }
  password  { 'secret' }
end
