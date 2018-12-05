require 'rails_helper'

feature 'Only author can delete the answer', %q{
  In order to delete the answer
  As an authenticated user
  As an author of my answer
  I'd like to be able to delete the answer
} do

  given(:user1) {create(:user) }
  given(:user2) {create(:user) }
  given!(:question) { create :question, author: user1 }

  describe 'Authenticate user' do
    background do
      sign_in(user1)
      visit questions_path
      click_on 'Answers'

      fill_in 'Body', with: 'text text text'
      click_on 'Post Your Answer'
    end

    scenario 'is author, delete the answer' do
      click_on 'Delete the Answer'
      expect(page).to have_no_content 'text text text'
    end

    scenario 'is not author delete the answer' do
      sign_out #user1
      sign_in(user2)

      visit questions_path
      click_on 'Answers'

      expect(page).to have_no_content 'Delete the Answer'
    end
  end
end