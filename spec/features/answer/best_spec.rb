require 'rails_helper'

feature 'Question Author can mark the best answer', %q{
  In order to mark the best answer to a community
  As an authenticated user
  As an author of the question
  I'd like to be able to choose the best answer
} do

  given(:user1) { create :user}
  given(:user2) { create :user}
  given!(:question) { create :question, author: user1}
  given!(:answer) { create :answer, question: question, author: user2 }

  scenario 'Unauthenticated user can not mark best answer' do
    visit question_path(question)

    expect(page).to_not have_button 'Mark as best answer'
  end

  describe 'Authenticated user', js: true do
    scenario 'is author of question tries to mark best answer. Test with reload page' do
      sign_in(user1)
      visit question_path(question)
      click_on 'Mark as best answer'

      expect(page).to have_content 'Best Answer!'
      expect(page).to_not have_button 'Mark as best answer'

      visit question_path(question)

      expect(page).to have_content 'Best Answer!'
      expect(page).to_not have_button 'Mark as best answer'

      click_on 'Cancel mark as best answer'

      expect(page).to_not have_content 'Best Answer!'
      expect(page).to have_button 'Mark as best answer'
    end

    scenario 'is NOT author of question tries to mark best answer' do
      sign_in(user2)
      visit question_path(question)

      expect(page).to_not have_button 'Mark as best answer'
    end
  end
end