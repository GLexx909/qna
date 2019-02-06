class Api::V1::AnswersController < Api::V1::BaseController

  def index
    @answers = question.answers
    render json: @answers, each_serializer: AnswersSerializer
  end

  def show
    @answer = Answer.find(params[:id])
    render json: @answer
  end

  def create
    answer = question.answers.new(answer_params)
    answer.author = current_resource_owner

    head :ok if answer.save
  end

  def update
    head :ok if answer.update(answer_params)
  end

  def destroy
    head :ok if answer.destroy
  end

  private

  def answer
    @answer ||= Answer.find(params[:id])
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
