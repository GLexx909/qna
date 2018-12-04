require 'rails_helper'

feature 'User can see questions list', %q{
  In order to get answer for any question
  I'd like to be able to see all questions
} do

  given(:user1) {create(:user) }
  given(:user2) {create(:user) }

  scenario 'User can see questions list' do
    # user1 sign_in, create a question, sign_out
    sign_in(user1)
    visit questions_path
    click_on 'Ask question'

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    click_on 'Ask'

    sign_out #user1

    # user2 sign_in, create a question, see all questions by another users
    sign_in(user2)
    visit questions_path
    click_on 'Ask question'

    fill_in 'Title', with: 'Test 2 question'
    fill_in 'Body', with: 'text 2 text text'
    click_on 'Ask'
    click_on 'QNA'

    expect(page).to have_content 'Test question'
    expect(page).to have_content 'Test 2 question'
    #Удалил, ибо @question.body в списке вопростов не нужны, как мне кажется.
  end
end