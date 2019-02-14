class DailyDigestMailer < ApplicationMailer
  def digest(user, questions_title)
    @questions_title = questions_title

    mail to: user.email
  end
end
