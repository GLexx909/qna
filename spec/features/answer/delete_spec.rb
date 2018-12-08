require 'rails_helper'

feature 'Only author can delete the answer', %q{
  In order to delete the answer
  As an authenticated user
  As the author of my answer
  I'd like to be able to delete the answer
} do

  given(:user1) {create(:user) }
  given(:user2) {create(:user) }
  given!(:question) { create :question, author: user1 }
  given!(:answer) { create :answer, question: question, author: user1 }

  describe 'Authenticated user' do
    scenario 'is author, delete the answer' do
      sign_in(user1)
      visit questions_path
      click_on 'Answers'
      click_on 'Delete the Answer'

      expect(page).to_not have_content answer.body
    end

    scenario 'is not author delete the answer' do
      sign_in(user2)
      visit questions_path
      click_on 'Answers'

      expect(page).to_not have_content 'Delete the Answer'
    end
  end

  scenario 'Unauthenticated user is not author delete the answer' do
    visit questions_path
    click_on 'Answers'

    expect(page).to_not have_content 'Delete the Answer'
  end
end