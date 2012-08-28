# Courseware classroom model
class Classroom < ActiveRecord::Base
  extend FriendlyId
  include PublicActivity::Model

  attr_accessible :description, :title

  # Relationships
  belongs_to(
    :owner, :counter_cache => :created_classrooms_count, :class_name => User
  )

  has_many :memberships, :dependent => :destroy
  has_many :members, :through => :memberships, :source => :user
  has_many :images, :dependent => :destroy
  has_many :uploads, :dependent => :destroy

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
  after_create :add_owner_to_memberships

  private
    # When creating a new classroom, owner becomes a member too
    def add_owner_to_memberships
      self.members << self.owner
    end
end
