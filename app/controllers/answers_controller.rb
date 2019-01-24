class AnswersController < ApplicationController
  include Voted
  before_action :authenticate_user!
  after_action :publish_answer, only: [:create]
  after_action :delete_answer, only: [:destroy]

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

    links = []
    answer.links.each do |link|
      if link.persisted? && link.gist?
        hash = Hash.new
        hash[:name] = link.name
        hash[:url] = link.url
        hash[:text] = link.gist_code
        links << hash
      elsif link.persisted?
        hash = Hash.new
        hash[:name] = link.name
        hash[:url] = link.url
        links << hash
      end
    end

    files = []
    answer.files.each do |file|
      hash = {}
      hash[:name] = file.filename.to_s
      hash[:url] = url_for(file)
      files << hash
    end

    files_names = []
    answer.files.each{|file| files_names << file.filename.to_s}

    ActionCable.server.broadcast(
        'answers', {action: 'create',
                    answer_id: answer.id,
                    answer_body: answer.body,
                    answer_files: files,
                    answer_links: links,
                    author: answer.author.id}
    )
  end

  def delete_answer
    ActionCable.server.broadcast(
        'answers', {action: 'delete', answer_id: answer.id}
    )
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url, :id, :_destroy])
  end
end
