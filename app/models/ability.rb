class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer, Comment], author_id: user.id
    can :destroy, [Question, Answer, Comment], author_id: user.id

    can :vote_up, [Question, Answer] do |votable| votable.author_id != user.id end
    can :vote_down, [Question, Answer] do |votable| votable.author_id != user.id end

    can :manage, ActiveStorage::Attachment do |attachment|
      attachment.record.author_id == user.id
    end

    can :mark_best, Answer, question: { author_id: user.id }
    can :destroy, Link, linkable: { author_id: user.id }
    can :index, My::BadgesController
  end
end
