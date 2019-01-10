class LinksController < ApplicationController

  def destroy
    link = Link.find(params[:id])
    resource = link.linkable

    if current_user.author_of?(resource)
      link.destroy
    else
      head 403
    end

    if resource.is_a?(Question)
      @question = resource
      @answer = @question.answers.new
    else resource.is_a?(Answer)
      @answer = resource
      @question = resource.question
    end
  end
end
