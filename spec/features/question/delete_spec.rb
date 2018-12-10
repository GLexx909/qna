require 'rails_helper'

feature 'Only author can delete the question', %q{
  In order to delete the question
  As an authenticated user
  As the author of the question
  I'd like to be able to delete the question
} do

  given(:user1) {create(:user) }
  given(:user2) {create(:user) }
  given!(:question) { create :question, author: user1 }

  describe 'Authenticated user' do
    scenario 'is author, delete the question' do
      sign_in(user1)
      visit questions_path
      click_on 'Answers'
      click_on 'Delete the Question'

      expect(page).to_not have_content question.title
    end

    scenario 'is not author delete the answer' do
      sign_in(user2)
      visit questions_path
      click_on 'Answers'

      expect(page).to_not have_content 'Delete the Question'
    end
  end

  scenario 'Unauthenticated user delete the question' do
    visit questions_path
    click_on 'Answers'

    expect(page).to_not have_content 'Delete the Question'
  end

end