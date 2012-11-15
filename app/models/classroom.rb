# Courseware classroom model
class Classroom < ActiveRecord::Base
  extend FriendlyId
  include PublicActivity::Model

  attr_accessible :description, :title

  # Dynamic settings store
  store :settings, :accessors => [:color_scheme, :header_image, :color]

  # Relationships
  belongs_to(
    :owner, :counter_cache => :created_classrooms_count, :class_name => User
  )

  has_many :memberships, :dependent => :destroy
  has_many :members, :through => :memberships, :source => :user
  has_many :collaborations, :dependent => :destroy
  has_many :collaborators, :through => :collaborations, :source => :user
  has_many :images
  has_many :uploads
  has_many :lectures
  has_one :syllabus

  # Validations
  validates_presence_of :title, :slug, :description
  validates_uniqueness_of :title, :case_sensitive => false
  validates_exclusion_of :title, :in => Courseware.config.domain_blacklist
  validates_length_of :title, :minimum => 4, :maximum => 32

  # Generate title slug
  friendly_id :title, :use => :slugged

  # Track activities
  tracked :owner => :owner, :only => [:create]

  # Callbacks
  # Cleanup title and description before saving it
  before_validation do
    self.title = Sanitize.clean(self.title)
    self.description = Sanitize.clean(
      self.description, Sanitize::Config::RESTRICTED)
  end
  # When creating a new classroom, owner becomes a member too
  after_create do |classroom|
    classroom.members << classroom.owner
  end

end
