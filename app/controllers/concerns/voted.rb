module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote_up, :vote_down]
  end

  def vote_up
    number = if @votable.voted?(current_user)
               user_vote.value == -1 ? 0 : 1
             end

    respond_to do |format|
      if user_vote
        user_vote.update(value: number)
        format.json { render json: @votable.rating }
      else
        @votable.votes.create(user_id: current_user.id, value: number)
        format.json { render json: @votable.rating }
      end
    end
  end

  def vote_down
    number = if @votable.voted?(current_user)
               user_vote.value == 1 ? 0 : -1
            end

    respond_to do |format|
      if user_vote
        user_vote.update(value: number)
        format.json { render json: @votable.rating }
      else
        @votable.votes.create(user_id: current_user.id, value: number)
        format.json { render json: @votable.rating }
      end
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def user_vote
    @votable.votes.find_by(user_id: current_user.id)
  end
end