# Many-to-many relationship between users and classrooms
class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :classroom
end
