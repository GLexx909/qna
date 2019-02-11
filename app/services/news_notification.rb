class Services::NewsNotification
  def send_question_updates(answer)
    users(answer).each do |user|
      NewsNotificationMailer.notify(user, answer).deliver_later
    end
  end

  private

  def subscriptions(answer)
    Subscription.where(question: answer.question)
  end

  def users(answer)
    subscriptions(answer).map{ |subscription| subscription.user }
  end
end
