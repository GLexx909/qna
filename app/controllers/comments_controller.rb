class CommentsController < ApplicationController
  before_action :authenticate_user!
  after_action :publish_comment, only: [:create]
  after_action :delete_comment, only: [:destroy]

  def create
    @comment = commentable.comments.new(comment_params)
    @comment.author = current_user
    @comment.save
  end

  def destroy
    @comment = Comment.find(params[:id])
    if current_user.author_of?(@comment)
      @comment.destroy
    else
      head 403
    end
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
        'comments', {action: 'create',
                     comment_id: @comment.id,
                     comment_body: @comment.body,
                     author: @comment.author.id})
  end

  def delete_comment
    ActionCable.server.broadcast(
        'comments', {action: 'delete',
                     comment_id: @comment.id,
                     author: @comment.author.id}
    )
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
