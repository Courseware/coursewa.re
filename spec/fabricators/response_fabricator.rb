Fabricator(:response) do
  content       Faker::HTMLIpsum.body
  user
  classroom     { |attr| Fabricate(:classroom, :owner => attr[:user]) }
  assignment    { |attr| Fabricate(
    :assignment, :user => attr[:user], :classroom => attr[:classroom]) }
end
