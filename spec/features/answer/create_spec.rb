require 'rails_helper'

feature 'User can create answer', %q{
  In order to send an answer to a community
  As an authenticated user
  I'd like to be able to create the answer
} do

  given(:user) {create(:user) }
  given!(:question) { create :question, author: user }


  describe 'Authenticate user' do
    background do
      sign_in(user)
      visit questions_path
      click_on 'Answers'
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

  scenario 'Unauthenticated user tries to create an answer' do
    visit questions_path
    click_on 'Answers'

    fill_in 'Body', with: 'Non auth text'
    click_on 'Post Your Answer'
    # Тут должен сработать post_answer_disabled.coffee
    # и вывести на экран 'You need to sign in or sign up before continuing.'
    # что по-сути и происходит в жизни
    # Но, походу, проверка expect делает своё дело быстрее, чем JS срабатывет.
    # Поэтому текст не виден.
    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end
end