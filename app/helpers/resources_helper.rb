module ResourcesHelper
  def path_to_resource(resource)
    case resource.class.name
    when 'User'
      false
    when 'Answer', 'Comment'
      question_path(resource.question)
    when 'Question'
      question_path(resource)
    else
      false
    end
  end

  def text_of_resource(resource)
    case resource.class.name
    when 'User'
      resource.email
    when 'Answer', 'Comment'
      resource.body
    when 'Question'
      resource.title
    else
      false
    end
  end

  def category_list
    %w(Global_Search User Question Answer Comment)
  end
end
