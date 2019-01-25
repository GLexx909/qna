require 'rails_helper'

feature 'User can delete comment of question', %q{
  As a registered user and author
  I'd like to be able to delete comment
}do
  given(:user) { create :user}
  given(:question) { create :question, author: user}
  given!(:answer) { create :answer, author: user, question: question}
  given!(:comment) { create :comment, author: user, commentable: answer, body: 'text of comment'}

  scenario 'User delete comment of answer', js: true do
    sign_in(user)
    visit question_path(question)

    within ('.answers') do
      click_on 'Delete comment'
      expect(page).to have_content 'text of comment'
    end
  end

  scenario 'Unauthorised user can not delete a comment of answer', js: true do
    visit question_path(question)

    within ('.answers') do
      expect(page).to_not have_link 'Delete Comment'
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
        expect(page).to have_content 'text of comment'
      end

      Capybara.using_session('user') do
        click_on 'Delete comment'

        expect(page).to_not have_content 'text of comment'
      end

      Capybara.using_session('guest') do
        expect(page).to_not have_content 'text of comment'
      end
    end
  end
end

require 'rails_helper'

feature 'User can delete comment of question', %q{
  As a registered user and author
  I'd like to be able to delete comment
}do
  given(:user) { create :user}
  given(:question) { create :question, author: user}
  given!(:comment) { create :comment, author: user, commentable: question, body: 'text of comment'}

  scenario 'User delete comment of question', js: true do
    sign_in(user)
    visit question_path(question)

    within ('.question-comments-block') do
      click_on 'Delete comment'
      expect(page).to have_content 'text of comment'
    end
  end

  scenario 'Unauthorised user can not delete a comment of question', js: true do
    sign_in(user)
    visit question_path(question)

    within ('.question-comments-block') do
      expect(page).to_not have_link 'Delete Comment'
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
        expect(page).to have_content 'text of comment'
      end

      Capybara.using_session('user') do
        click_on 'Delete comment'

        expect(page).to_not have_content 'text of comment'
      end

      Capybara.using_session('guest') do
        expect(page).to_not have_content 'text of comment'
      end
    end
  end
end
