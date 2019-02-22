class QuestionsController < ApplicationController
  include Voted
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_subscription, only: [:show]
  after_action :publish_question, only: [:create]
  after_action :delete_question, only: [:destroy]

  authorize_resource

  def index
    @questions = Question.all.paginate(page: params[:page], per_page: 10)
  end

  def show
    @answer = question.answers.new
    gon.user_id = current_user&.id
  end

  def new
    question.links.new
    question.build_badge
  end

  def create
    @question = Question.new(question_params)
    @question.author = current_user
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    if current_user&.author_of?(question)
      question.update(question_params)
    else
      head 403
    end
  end

  def destroy
    if current_user&.author_of?(question)
      question.destroy
      redirect_to questions_path, notice: 'The Question was successfully deleted.'
    else
      head 403
    end
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  helper_method :question

  def publish_question
    return if question.errors.any?

    ActionCable.server.broadcast(
        'questions', {action: 'create', data:
        ApplicationController.render(
          partial: 'questions/question',
          locals: { question: question }
        )}
    )
  end

  def delete_question
    ActionCable.server.broadcast(
        'questions', {action: 'delete', data: question.id}
    )
  end

  def find_subscription
    @subscription ||= current_user&.subscribed_to(@question)
  end

  def question_params
    params.require(:question)
        .permit(:title, :body, files: [],
                links_attributes: [:name, :url, :id, :_destroy],
                badge_attributes: [:name, :img])
  end
end
