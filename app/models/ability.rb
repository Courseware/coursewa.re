# Courseware user abilities
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.role == :admin
      can :manage, :all
    else
      # Can be created/activated if only visitor is not registered
      can :create, User do
        user.id.nil?
      end

      # Allow nothing if not logged in
      return if user.id.nil?

      ######################

      # Can read any page if logged in
      can [:show, :read], :all

      # Can be updated if only visitor owns it
      can :manage, User, :id => user.id

      # Can not create nother user
      cannot :create, User

      # Can manage a classroom if its the owner
      can :manage, Classroom, :owner_id => user.id

      # Can create a classroom if logged in and plan allows it
      can :create, Classroom do
        !user.id.nil? and user.classrooms.count < user.plan.allowed_classrooms
      end

      # Can access classroom if only a member
      can :dashboard, Classroom do |classroom|
        classroom.members.include?(user)
      end

      can :read, :all

    end

  end
end
