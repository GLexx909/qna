class AnswersController < ApplicationController

  before_action :authenticate_user!

  def create
    @answer = question.answers.new(answer_params)
    @answer.author = current_user
    @answer.save
  end

  def update
    if current_user.author_of?(answer)
      answer.update(answer_params)
      @question = answer.question
    else
      head 403
    end
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
    else
      head 403
    end
  end

  def mark_best
    if current_user.author_of?(answer.question)
      answer.change_mark_best
      @question = answer.question
    else
      head 403
    end
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : question.answers.new
  end

  helper_method :answer

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
