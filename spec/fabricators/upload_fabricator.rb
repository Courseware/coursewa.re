include ActionDispatch::TestProcess

Fabricator(:upload) do
  description   { sequence(:upload){ Faker::HipsterIpsum.paragraph } }
  attachment    { fixture_file_upload('spec/fixtures/test.txt', 'text/plain') }
  user
  classroom
end
