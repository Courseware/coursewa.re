Fabricator(:user) do
  username  { Faker::Internet.user_name }
  email     { |attrs| "#{attrs[:user_name]}@#{Courseware.config.domain_name}" }
end
