Fabricator(:announcement, :class_name => 'public_activity/activity') do
  key         { 'announcement.create' }
  recipient(:fabricator => 'coursewareable/classroom')
  owner       { |attr|  attr[:recipient].owner }
  parameters  { |attr| {
    :content => Faker::Lorem.paragraph,
    :user_name => attr[:recipient].owner.name
  } }
end
