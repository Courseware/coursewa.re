# Many-to-many relationship between users and classrooms
class Membership < ActiveRecord::Base
  belongs_to :user, :counter_cache => true
  belongs_to :classroom, :counter_cache => true
end
