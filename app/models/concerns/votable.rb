module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def rating
    votes.sum(:value)
  end

  def voted?(current_user)
    votes.where(user_id: current_user.id).exists?
  end
end
