class Services::DailyDigest
  def send_digest
    questions = Question.where(created_at: (Time.now.midnight - 1.day)..Time.now.midnight)
    questions_title = questions.pluck(:title)

    User.find_each(batch_size: 500) do |user|
      DailyDigestMailer.digest(user, questions_title).deliver_later
    end
  end
end
