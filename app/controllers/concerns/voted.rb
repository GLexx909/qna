module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote_up, :vote_down]
  end

  def vote_up
    vote_response(:vote_up)
  end

  def vote_down
    vote_response(:vote_down)
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def vote_response(vote_method)
    return head 403 if current_user&.author_of?(@votable)

    if @votable.send(vote_method, current_user)
      render json: {rating: @votable.rating, votable_id: @votable.id }
    else
      head 403
    end
  end
end
