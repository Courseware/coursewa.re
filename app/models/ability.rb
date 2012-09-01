# Courseware user abilities
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.role == :admin
      can :manage, :all
    else
      # Can be created/activated if only visitor is not registered
      can :create, User if user.id.nil?

      # Allow nothing if not logged in
      return if user.id.nil?

      ######################

      # Can read any page if logged in
      can [:show, :read], :all

      # Can be updated if only visitor owns it
      can :manage, User, :id => user.id

      # Can not create another user
      cannot :create, User

      # Can manage a classroom if its the owner
      can [:update, :destroy], Classroom, :owner_id => user.id

      # Can access classroom if only a member
      can :dashboard, Classroom do |classroom|
        classroom.members.include?(user)
      end

      # Can manage assets if user is the owner
      can :manage, Image, :user_id => user.id
      can :manage, Upload, :user_id => user.id
      # Can create assets
      can :create, Image
      can :create, Upload

      # Can not create a classroom if plan limits reached
      if user.created_classrooms_count < user.plan.allowed_classrooms
        can :create, Classroom
      end

    end

  end
end
