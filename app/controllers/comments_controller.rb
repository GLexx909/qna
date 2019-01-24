class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = question.comments.new(comment_params)
    @comment.author = current_user
    @comment.save
  end

  def destroy
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
