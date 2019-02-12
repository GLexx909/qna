class Services::NewsNotification
  def send_question_updates(answer)
    subscribers = answer.question.subscribers

    subscribers.each do |user|
      NewsNotificationMailer.notify(user, answer).deliver_later
    end
  end
end
