class AnswerHash
  # include ActionController::UrlFor
  # include ActionDispatch::Routing::UrlFor
  # include Rails.application.routes.url_helpers

  def initialize(answer, *urls)
    @answer = answer
    @urls = urls
  end

  def call_create
    { answer: @answer.as_json.merge(action: 'create', files: files(@answer, @urls), links: links(@answer)) }
  end

  def call_delete
    { answer: @answer.as_json.merge(action: 'delete') }
  end

  private

  def links(answer)
    links = []
    answer.links.each do |link|
      if link.persisted?
        hash = Hash.new
        hash[:name] = link.name
        hash[:url] = link.url
        hash[:text] = link.gist_code if link.gist?
        links << hash
      end
    end
    links
  end

  def files(answer, urls)
    files = []
    answer.files.each do |file|
      hash = Hash.new
      hash[:name] = file.filename.to_s
      hash[:url] = urls
      files << hash
    end
    files
  end
end
