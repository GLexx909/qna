require 'rails_helper'

feature 'User can add comments to question', %q{
  In order to provide additional info to question
  As a registered user
  I'd like to be able to add comment
}do
  given(:user) { create :user}
  given(:question) { create :question, author: user}

  scenario 'User adds comment to question', js: true do
    sign_in(user)
    visit question_path(question)

    within ('.question-comments-block') do
      click_on 'Comment this'
      fill_in 'Body', with: 'text of comment'
      click_on 'Post Your Comment'
      expect(page).to have_content 'text of comment'
    end
  end

  scenario 'Unauthorised user tries to can not add a comment to question', js: true do
    sign_in(user)
    visit question_path(question)

    within ('.question-comments-block') do
      click_on 'Comment this'
      fill_in 'Body', with: 'text of comment'
      click_on 'Post Your Comment'
      expect(page).to have_content 'text of comment'
    end
  end
end
