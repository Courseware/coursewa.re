# STI instance of [Association] to handle [Classroom] memberships
class Membership < Association
  belongs_to :user, :counter_cache => true
  belongs_to :classroom, :counter_cache => true
end
