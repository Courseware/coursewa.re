# Courseware User model
class User < ActiveRecord::Base
  include PublicActivity::Model

  authenticates_with_sorcery!

  attr_accessible :email, :password, :password_confirmation

  # Relationships
  has_many :groups, :dependent => :destroy

  # Validations
  validates_confirmation_of :password
  validates_presence_of :password, { on: :create }
  validates_length_of :password, :minimum => 6, :maximum => 32

  validates_presence_of :email
  validates_uniqueness_of :email

  # Enable public activity
  activist

  # Helper to generate user's name
  def name
    return '%s %s' % [first_name, last_name] if first_name and last_name
    email
  end

end
