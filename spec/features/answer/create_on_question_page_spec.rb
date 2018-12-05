require 'rails_helper'

feature 'User can create answer on the particular question page', %q{
  In order to create an answer
  On the particular question page
  I'd like to be able to do it
} do

  given(:user) {create(:user) }
  given!(:question) { create :question, author: user }

  describe 'Authenticate user' do
    background do
      sign_in(user)
      visit questions_path

      click_on 'Answers'
    end

    scenario 'asks a question' do
      fill_in 'Body', with: 'text of answer'
      click_on 'Post Your Answer'

      expect(page).to have_content 'text of answer'
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end