require 'rails_helper'

feature 'User can create answer on the particular question page', %q{
  In order to create an answer
  On the particular question page
  I'd like to be able to do it
} do

  given(:user1) {create(:user) }
  given(:user2) {create(:user) }

  background do
    sign_in(user1)
    visit questions_path
    click_on 'Ask question'

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text of question'
    click_on 'Ask'

    sign_out #user1
  end

  describe 'Authenticate user' do
    background do
      sign_in(user2)
      visit questions_path
      click_on 'Answers'
    end

    scenario 'asks a question' do
      fill_in 'Body', with: 'text of answer'
      click_on 'Post Your Answer'

      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text of question'
      expect(page).to have_content 'text of answer'
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