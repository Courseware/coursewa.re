# Courseware classroom model
class Classroom < ActiveRecord::Base
  extend FriendlyId

  attr_accessible :description, :title

  # Relationships
  belongs_to :user, :counter_cache => true

  # Validations
  validates_presence_of :title, :slug, :description
  validates_uniqueness_of :title, :case_sensitive => false
  validates_exclusion_of :title, :in => Courseware.config.domain_blacklist
  validates_length_of :title, :minimum => 4, :maximum => 32

  # Generate title slug
  friendly_id :title, :use => :slugged
end
