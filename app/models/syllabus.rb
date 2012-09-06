# Courseware [Classroom] syllabus
class Syllabus < ActiveRecord::Base
  include PublicActivity::Model

  attr_accessible :content, :intro, :title

  # Relationships
  belongs_to :user
  belongs_to :classroom
  has_many :images, :as => :assetable, :class_name => Image
  has_many :uploads, :as => :assetable, :class_name => Image

  # Validations
  validates_presence_of :title, :content

  # Track activities
  tracked :owner => :user, :recipient => :classroom

  # Callbacks
  # Cleanup title, content and intro
  before_validation do
    self.title = Sanitize.clean(self.title)
    self.content = Sanitize.clean(self.content, Sanitize::Config::RELAXED)
    self.intro = Sanitize.clean(self.intro)
  end
end
