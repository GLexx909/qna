require 'rails_helper'

feature 'User can create answer', %q{
  In order to send an answer to a community
  As an authenticated user
  I'd like to be able to create the answer
} do

  given(:user) {create(:user) }

  describe 'Authenticate user' do
    background do
      sign_in(user)
      visit questions_path
      click_on 'Ask question'

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text of question'
      click_on 'Ask'
    end

    scenario 'create an answer' do
      fill_in 'Body', with: 'text text text'
      click_on 'Post Your Answer'

      expect(page).to have_content 'text text text'
    end

    scenario 'asks a question with error' do
      click_on 'Post Your Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end