# Courseware User model
class User < ActiveRecord::Base
  authenticates_with_sorcery!

  attr_accessible :email, :password, :password_confirmation

  # Validations
  validates_confirmation_of :password
  validates_presence_of :password, { on: :create }
  validates_length_of :password, :minimum => 6, :maximum => 32

  validates_exclusion_of :username, :in => Courseware.config.domain_blacklist
  validates_uniqueness_of :username, :case_sensitive => false
  validates_format_of :username,:with => /^[a-z0-9\-]+$/
  validates_length_of :username, :minimum => 1, :maximum => 32
  validates_presence_of :username

  validates_presence_of :email
  validates_uniqueness_of :email

  # Helper to generate user's name
  def name
    return '%s %s' % [first_name, last_name] if first_name and last_name
    username
  end

end
