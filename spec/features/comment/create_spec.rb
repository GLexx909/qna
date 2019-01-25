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

  context 'multiple session', js: true do
    scenario "comment appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        click_on 'Comment this'
        within('.question-comment-form') do
          fill_in 'Body', with: 'text text text'
          click_on 'Post Your Comment'
        end

        expect(page).to have_content 'text text text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'text text text'
      end
    end
  end
end
