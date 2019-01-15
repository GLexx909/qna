module Voted
  extend ActiveSupport::Concern

  def vote_up
    if voted?
      votes.find_by_user(current_user).delete
    else
      votes.create!(user: current_user, value: 1)
    end
  end

  def vote_down
    if voted?
      votes.find_by_user(current_user).delete
    else
      votes.create!(user: current_user, value: -1)
    end
  end
end
