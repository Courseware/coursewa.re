# Courseware user plan model
class Plan < ActiveRecord::Base

  attr_accessible :allowed_classrooms, :allowed_space, :expires_in, :slug

  # Relationships
  belongs_to :user

  # Validations
  validates_inclusion_of(
    :slug, :in => Courseware.config.plans.keys.collect(&:to_s)
  )
end
