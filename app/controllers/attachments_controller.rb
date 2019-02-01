class AttachmentsController < ApplicationController

  def destroy
    file = ActiveStorage::Attachment.find(params[:id])
    authorize! :manage, file

    if current_user.author_of?(file.record)
      file.purge
    else
      return head 403
    end

    if file.record.is_a?(Question)
      @question = file.record
      @answer = @question.answers.new
    else file.record.is_a?(Answer)
      @answer = file.record
      @question = file.record.question
    end
  end
end
