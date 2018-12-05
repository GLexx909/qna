require 'rails_helper'

feature 'Only author can delete the question', %q{
  In order to delete the question
  As an authenticated user
  As an author of the question
  I'd like to be able to delete the question
} do

  given(:user1) {create(:user) }
  given(:user2) {create(:user) }
  # given!(:question) { create(:question) }

  describe 'Authenticate user' do

    background do
      sign_in(user1)
      visit questions_path
      click_on 'Ask question'

      fill_in 'Title', with: 'Title text'
      fill_in 'Body', with: 'Title body'
      click_on 'Ask'
    end

    scenario 'is author, delete the question' do
      click_on 'Delete the Question'
      expect(page).to have_content 'The Question was successfully deleted.'
    end

    scenario 'is not author delete the answer' do
      sign_out #user1
      sign_in(user2)
      visit questions_path
      click_on 'Answers'

      expect(page).to have_no_content 'Delete the Question'
    end

  end

end