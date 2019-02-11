class Services::DailyDigest
  def send_digest
    questions = Question.select {|question| question.created_at.to_date == Date.yesterday }
    questions_title = questions.pluck(:title)

    User.find_each(batch_size: 500) do |user|
      DailyDigestMailer.digest(user, questions_title).deliver_later
    end
  end
end
