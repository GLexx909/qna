require 'rails_helper'

feature 'User can vote for a question', %q{
  In order to improve the rating of a question
  As an authorized user
  I'd like to be able to vote
}do
  given(:user) { create :user}
  given(:question) { create :question, author: user}

  scenario 'User vote for a question', js: true do
    sign_in(user)
    visit question_path(question)

    within('.question-vote') do
      find('.vote-up a').click
      expect(page).to have_css('.vote-up a')
      expect(page).to have_css('.vote-down a')
      expect(page).to have_content('0')
      # expect(page).to have_content '1'
    end
  end
end
