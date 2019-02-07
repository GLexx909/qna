class Api::V1::QuestionsController < Api::V1::BaseController
  # authorize_resource
  # skip_authorization_check

  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    @question = Question.find(params[:id])
    render json: @question
  end

  def create
    @question = Question.new(question_params)
    @question.author = current_resource_owner

    head :ok if @question.save!
  end

  def update
    head :ok if question.update(question_params)
  end

  def destroy
    head :ok if question.destroy
  end

  private

  def question
    @question ||= Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
