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

      # Can not create a classroom if plan limits reached
      if user.created_classrooms_count < user.plan.allowed_classrooms
        can :create, Classroom
      end

      # Can create own classroom memberships
      can :create, Membership do |mem|
        user.created_classrooms.include?(mem.classroom)
      end
      # Can remove own classroom membership
      can :destroy, Membership do |mem|
        user.equal?(mem.user) or
          user.created_classrooms.include?(mem.classroom)
      end

      # Can not add a classroom collaborator if limit reached
      if user.collaborations_count < user.plan.allowed_collaborators
        can :create, Collaboration do |col|
          user.created_classrooms.include?(col.classroom)
        end
      end
      # Can remove own classroom collaboration
      can :destroy, Collaboration do |col|
        user.equal?(col.user) or
          user.created_classrooms.include?(col.classroom)
      end

      # Can manage assets if user is the owner
      can :manage, Image, :user_id => user.id
      can :manage, Upload, :user_id => user.id
      # Can create assets
      can :create, Image
      can :create, Upload

      # Can manage lectures if user is the owner
      can :manage, Lecture do |lecture|
        lecture.classroom.collaborators.include?(user)
      end
      # Can create lectures if user owns the classroom
      can :create, Lecture do |lecture|
        lecture.classroom.owner.equal?(lecture.user)
      end
      # Can access lecture if user is a member of the classroom
      can :read, Lecture do |lecture|
        lecture.classroom.members.include?(user)
      end
    end

  end
end
