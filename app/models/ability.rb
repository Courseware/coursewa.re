# Courseware user abilities
class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new # guest user (not logged in)

    if @user.role == :admin
      admin_abilities
    else
      visitor_abilities

      # Allow nothing if not logged in
      return if @user.id.nil?

      ######################

      %w(user classroom membership collaboration assets syllabus lecture
        assignment response).each do |component|
        self.send("#{component}_abilities")
      end
    end
  end

  # [User] abilities with role :admin
  def admin_abilities
    can :manage, :all
  end

  # Visitor aka unknown [User] abilities
  def visitor_abilities
    # Can be created/activated if only visitor is not registered
    can :create, User if @user.id.nil?
  end

  # [User] abilities with no role, aka ordinary user
  def user_abilities
    # Can be updated if only visitor owns it
    can :manage, User, :id => @user.id

    # Can not create another user
    cannot :create, User
  end

  # [Classroom] relevant abilities
  def classroom_abilities
    # Can manage a classroom if its the owner
    can [:update, :destroy], Classroom, :owner_id => @user.id

    # Can access classroom if only a member
    can :dashboard, Classroom do |classroom|
      classroom.members.include?(@user) or
        classroom.collaborators.include?(@user)
    end

    # Can not create a classroom if plan limits reached
    if @user.created_classrooms_count < @user.plan.allowed_classrooms
      can :create, Classroom
    end
  end

  # [Classroom] [Membership] relevant abilities
  def membership_abilities
    # Can create own classroom memberships
    can :create, Membership do |mem|
      mem.classroom.owner.equal?(@user)
    end
    # Can remove own classroom membership
    can :destroy, Membership do |mem|
      mem.user.equal?(@user) or mem.classroom.owner.equal?(@user)
    end
  end

  # [Classroom] [Collaboration] relevant abilities
  def collaboration_abilities
    # Can not add a classroom collaborator if limit reached
    if @user.collaborations_count < @user.plan.allowed_collaborators
      can :create, Collaboration do |col|
        col.classroom.owner.equal?(@user)
      end
    end
    # Can remove own classroom collaboration
    can :destroy, Collaboration do |col|
      col.user.equal?(@user) or col.classroom.owner.equal?(@user)
    end
  end

  # [Classroom] [Asset] relevant abilities, aka [Upload] and [Image]
  def assets_abilities
    # Can manage assets if user is the owner
    can :manage, Image, :user_id => @user.id
    can :manage, Upload, :user_id => @user.id
    # Can create assets
    can :create, Image
    can :create, Upload
  end

  # [Classroom] [Syllabus] relevant abilities
  def syllabus_abilities
    # Can manage syllabus if user is the owner or collaborator
    can :manage, Syllabus do |syl|
      syl.classroom.collaborators.include?(@user) or
        syl.classroom.owner.equal?(@user)
    end
    # Can access syllabus if user is a member of the classroom
    can :read, Syllabus do |syl|
      syl.classroom.members.include?(@user)
    end
  end

  # [Classroom] [Lecture] relevant abilities
  def lecture_abilities
    # Can manage lectures if user is the owner or collaborator
    can :manage, Lecture do |lecture|
      lecture.classroom.collaborators.include?(@user) or
        lecture.classroom.owner.equal?(@user)
    end
    # Can access lecture if user is a member of the classroom
    can :read, Lecture do |lecture|
      lecture.classroom.members.include?(@user)
    end
  end

  # [Classroom] [Assignment] relevant abilities
  def assignment_abilities
    # Can manage assignment if user is the owner or collaborator
    can :manage, Assignment do |assignment|
      assignment.classroom.collaborators.include?(@user) or
        assignment.classroom.owner.equal?(@user)
    end
    # Can access assignment if user is a member of the classroom
    can :read, Assignment do |assignment|
      assignment.classroom.members.include?(@user)
    end
  end

  # [Classroom] [Response] relevant abilities
  def response_abilities
    # Can manage response if user is the owner or collaborator
    can :destroy, Response do |resp|
      resp.classroom.collaborators.include?(@user) or
        resp.classroom.owner.equal?(@user)
    end
    # Can create response if user is a classroom member
    can :create, Response do |resp|
      resp.classroom.members.include?(@user)
    end
    # Can access response if user is a member of the classroom
    can :read, Response do |resp|
      resp.classroom.collaborators.include?(@user) or
        resp.classroom.owner.equal?(@user) or
        resp.user.equal?(@user)
    end
  end
end
