require 'rails_helper'

feature 'User can see his badges list', %q{
  In order to know info about my badges
  I'd like to be able to see all my badges
} do

  given!(:user) { create(:user) }
  given!(:question1) { create :question, author: user }
  given!(:question2) { create :question, author: user }
  given!(:answer1) { create :answer, author: user, question: question1, best: true }
  given!(:answer2) { create :answer, author: user, question: question2, best: true }
  given!(:badge1) { create :badge, question: question1 }
  given!(:badge2) { create :badge, question: question2 }

  scenario 'User can see questions list' do
    sign_in(user)
    visit my_badges_path

    user.answers.best.each do |answer|
      expect(page).to have_content answer.question.title
      expect(page).to have_content answer.question.badge.name
      expect(page).to have_css("img")
    end
  end
end
