class CommentsController < ApplicationController
  before_action :authenticate_user!
  after_action :publish_comment, only: [:create]

  def create
    @comment = commentable.comments.new(comment_params)
    @comment.author = current_user
    @comment.save
  end

  def destroy
  end

  private

  def commentable
    if params[:question_id]
      Question.find(params[:question_id])
    elsif params[:answer_id]
      Answer.find(params[:answer_id])
    end
  end

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast(
        'comments', {action: 'create', data:
        ApplicationController.render(
            partial: 'comments/comment',
            locals: { comment: @comment }
        )}
    )
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
