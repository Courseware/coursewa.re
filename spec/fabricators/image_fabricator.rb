include ActionDispatch::TestProcess

Fabricator(:image) do
  description   { sequence(:image){ Faker::HipsterIpsum.paragraph } }
  attachment    { fixture_file_upload('spec/fixtures/test.png', 'image/png') }
  user
  classroom
end
