module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def rating
    votes.sum(:value)
  end

  def vote_up(user)
    if user_vote(user)&.value == -1
      user_vote(user).destroy
    elsif !user_vote(user)
      votes.create(user: user, value: 1)
    end
  end

  def vote_down(user)
    if user_vote(user)&.value == 1
      user_vote(user).destroy
    elsif !user_vote(user)
      votes.create(user: user, value: -1)
    end
  end

  private

  def user_vote(user)
    votes.find_by(user_id: user.id)
  end
end
