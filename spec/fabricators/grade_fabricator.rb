Fabricator(:grade) do
  form        :number
  mark        { rand(1..10) }
  comment     Faker::HTMLIpsum.body
  user
  classroom   { |attr| Fabricate(:classroom, :owner => attr[:user]) }
  assignment  { |attr| Fabricate(
    :assignment, :user => attr[:user], :classroom => attr[:classroom]) }
  receiver    { |attr| Fabricate(
    :membership, :classroom => attr[:classroom]).user }
end
