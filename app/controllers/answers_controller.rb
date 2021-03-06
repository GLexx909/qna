class AnswersController < ApplicationController
  include Voted
  before_action :authenticate_user!
  after_action :publish_answer, only: [:create]
  after_action :delete_answer, only: [:destroy]

  authorize_resource

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

  def publish_answer
    return if answer.errors.any?
    # Не смог метод url_for вызвать в AnswerHash.rb
    urls = answer.files.map{ |file| url_for(file) }

    ActionCable.server.broadcast("answers_of_question_#{answer.question_id}", AnswerHash.new(answer, urls).call_create)
  end

  def delete_answer
    ActionCable.server.broadcast("answers_of_question_#{answer.question_id}", AnswerHash.new(answer).call_delete)
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url, :id, :_destroy])
  end
end
