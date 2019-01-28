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

    ActionCable.server.broadcast("comments_of_question_#{question_id}", { comment: @comment.as_json.merge(action: 'create') })
  end

  def delete_comment
    ActionCable.server.broadcast("comments_of_question_#{question_id}", { comment: @comment.as_json.merge(action: 'delete') })
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def question_id
    if @comment.commentable_type == "Question"
      @comment.commentable_id
    elsif @comment.commentable_type == "Answer"
      @comment.commentable.question_id
    end
  end
end
