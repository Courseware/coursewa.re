# Courseware User model
class User < ActiveRecord::Base
  authenticates_with_sorcery!

  attr_accessible :email, :password, :password_confirmation

  # Validations
  validates_confirmation_of :password
  validates_presence_of :password, { on: :create }

  validates_presence_of :username
  validates_presence_of :email

  validates_uniqueness_of :username
  validates_uniqueness_of :email

  # Helper to generate user's name
  def name
    return '%s %s' % [first_name, last_name] if first_name and last_name
    username
  end

end
