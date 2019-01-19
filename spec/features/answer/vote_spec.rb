require 'rails_helper'

feature 'User can vote for an answer', %q{
  In order to improve the rating of an answer
  As an authorized user
  I'd like to be able to vote
}do
  given!(:user) { create :user}
  given!(:user2) { create :user}
  given!(:question) { create :question, author: user}
  given!(:answer) { create :answer, question: question, author: user}

  describe 'Not author vote for an answer' do
    before do
      sign_in(user2)
      visit question_path(question)
    end

    scenario 'vote up', js: true do
      within(".answer-vote-#{answer.id}") do
        find('.vote-up').click
        expect(page).to have_content '1'
      end
    end

    scenario 'vote down', js: true do
      within(".answer-vote-#{answer.id}") do
        find('.vote-down').click
        expect(page).to have_content '-1'
      end
    end

    scenario 'vote up twice', js: true do
      within(".answer-vote-#{answer.id}") do
        find('.vote-up').click
        find('.vote-up').click
        expect(page).to have_content '1'
      end
    end

    scenario 'vote down twice', js: true do
      within(".answer-vote-#{answer.id}") do
        find('.vote-down').click
        find('.vote-down').click

        expect(page).to have_content '-1'
      end
    end

    scenario 'and cancel up-vote' do
      within(".answer-vote-#{answer.id}") do
        find('.vote-up').click
        find('.vote-down').click

        expect(page).to have_content '0'
      end
    end

    scenario 'and cancel down-vote' do
      within(".answer-vote-#{answer.id}") do
        find('.vote-down').click
        find('.vote-up').click

        expect(page).to have_content '0'
      end
    end
  end

  describe 'Author tries to vote for an answer, but can not' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'vote up', js: true do
      within(".answer-vote-#{answer.id}") do
        expect(page).to_not have_css 'vote-up'
      end
    end

    scenario 'vote down', js: true do
      within(".answer-vote-#{answer.id}") do
        expect(page).to_not have_css 'vote-down'
      end
    end
  end
end
