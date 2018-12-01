class AnswersController < ApplicationController

  before_action :find_question, only: %w(index new create)

  def index
    @answers = @question.answers
  end

  def show
    @answer = Answer.find(params[:id])
  end

  def new
    @answer = @question.answers.new
  end

  def edit
    @answer = Answer.find(params[:id])
  end

  def create
    @answer = @question.answers.new(answer_params)

    if @answer.save
      redirect_to @answer
    else
      render :new
    end
  end

  def update
    @answer = Answer.find(params[:id])

    if @answer.update(answer_params)
      redirect_to @answer
    else
      render :edit
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    if @answer.destroy
      redirect_to question_answers_path(@answer.question)
    else
      render :show
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
