class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)]

    default_abilities

    organization_admin_abilities(user) if user.has_role? :organization_admin

    if user.admin?
      admin_abilities
    elsif !user.new_record?
      regular_user_abilities(user)
    end
  end

  private

  def default_abilities
    can :read, DevSite
    can :read, Event
    can :read, Profile
    can [:new, :create], User
    can :read, Comment
    can :read, Conversation
    can :create, NewsletterSubscription
    can :create, CityRequest
    can :index, Municipality
    can :read, Organization
  end

  def admin_abilities
    can :manage, :all
  end

  def organization_admin_abilities(user)
    can :manage, Organization, memberships: { user: { id: user.id } }
    can :manage, DevSite
    can :manage, Status
    can :manage, Meeting
    can :manage, Notification
    can :manage, Comment
  end

  def regular_user_abilities(user)
    can :read, DevSite
    can :read, Event
    can [:new, :create, :update, :edit, :destroy, :show], User, id: user.id
    can :manage, Profile, user_id: user.id
    can :manage, NotificationSetting, user_id: user.id
    can :manage, Comment, user_id: user.id
    can :read, Comment
    can :manage, Vote, user_id: user.id
    can :manage, Conversation, user_id: user.id
  end
end
