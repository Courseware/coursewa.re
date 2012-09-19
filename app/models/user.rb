# Courseware User model
class User < ActiveRecord::Base
  include PublicActivity::Model

  # [User] email validation regex
  EMAIL_FORMAT = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  authenticates_with_sorcery!

  attr_accessible :email, :password, :password_confirmation,
    :first_name, :last_name

  # Relationships
  has_many(
    :created_classrooms, :dependent => :destroy,
    :class_name => Classroom, :foreign_key => :owner_id
  )
  has_one :plan

  has_many :memberships, :dependent => :destroy
  has_many :collaborations, :dependent => :destroy
  has_many :classrooms, :through => :memberships
  has_many :images
  has_many :uploads
  has_many :lectures
  has_many :assignments
  has_many :responses, :dependent => :destroy
  has_many :grades
  has_many(
    :received_grades, :dependent => :destroy,
    :foreign_key => :receiver_id, :class_name => Grade
  )

  # Validations
  validates_confirmation_of :password
  validates_presence_of :password, { on: :create }
  validates_length_of :password, :minimum => 6, :maximum => 32

  validates_presence_of :email
  validates_uniqueness_of :email
  validates_format_of :email, :with => EMAIL_FORMAT, :on => :create

  # Enable public activity
  activist

  # Hooks
  before_create do |user|
      plan = Courseware.config.plans[:free]
      user.plan = Plan.create(plan.except(:cost))
  end

  # Helper to generate user's name
  def name
    return [first_name, last_name].join(' ') if first_name and last_name
    email
  end

end
