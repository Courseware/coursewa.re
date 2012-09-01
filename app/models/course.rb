# [Classroom] course
class Course < ActiveRecord::Base
  extend FriendlyId
  include PublicActivity::Model

  attr_accessible :content, :requisite, :title

  # Relationships
  belongs_to :parent_course, :class_name => Course
  belongs_to :user
  belongs_to :classroom

  # Validations
  validates_presence_of :title, :slug, :content
  validates_uniqueness_of :title, :scope => :classroom_id

  # Generate title slug
  friendly_id :title, :use => :scoped, :scope => :classroom

  # Track activities
  tracked :owner => :user, :recipient => :classroom

  # Callbacks
  # Cleanup title and description before saving it
  before_validation do
    self.title = Sanitize.clean(self.title)
    self.content = Sanitize.clean(self.content, Sanitize::Config::RELAXED)
    self.requisite = Sanitize.clean(
      self.requisite, Sanitize::Config::RESTRICTED)
  end
end
