# Courseware user plan model
class Plan < ActiveRecord::Base
  attr_accessible(
    :allowed_classrooms, :allowed_space, :allowed_collaborators, :expires_in,
    :slug, :used_space
  )

  # Relationships
  belongs_to :user

  # Validations
  validates_inclusion_of(
    :slug, :in => Courseware.config.plans.keys.collect
  )

  # Calculate space left using this plan
  # @return [Fixnum]
  def left_space
    allowed_space - used_space
  end

end
