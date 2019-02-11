class AnswerNewNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Services::NewsNotification.new.send_question_updates(answer)
  end
end
