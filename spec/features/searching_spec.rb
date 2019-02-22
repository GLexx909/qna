require 'sphinx_helper'

feature 'User can use Search', %q{
  Every user can use Search panel
  to find users, questions and etc.
} do
  given!(:user) { create(:user, email: 'test@test.com') }
  given!(:question) { create(:question, author: user, title: 'test') }
  given!(:answer) { create(:answer, question: question, author: user, body: 'test')}
  given!(:comment) { create(:comment, commentable: answer, author: user, body: 'test')}

  %w(User Question Answer Comment).each do |klass|
    scenario "Try to find #{klass}", js: true do
      ThinkingSphinx::Test.run do
        visit root_path

        within('.search-block') do
          select klass, from: 'category'
          fill_in 'search', with: 'test'
          click_on 'Find it'
        end

        expect(current_path).to eq searches_path
        expect(page).to have_content('test')

        if klass != 'User'
          expect(page).to have_link("to #{klass}")
        end
      end
    end
  end

  scenario "Try to find with Global_Search", js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      within('.search-block') do
        select 'Global_Search', from: 'category'
        fill_in 'search', with: 'test'
        click_on 'Find it'
      end

      expect(current_path).to eq searches_path
      expect(page).to have_content('test')

      expect(page).to have_link("to Question")
      expect(page).to have_link("to Answer")
      expect(page).to have_link("to Comment")
    end
  end

  scenario "Try to find with blank query", js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      within('.search-block') do
        select 'Global_Search', from: 'category'
        fill_in 'search', with: ''
        click_on 'Find it'
      end

      expect(page).to have_content('Поле не может быть пустым')
    end
  end
end
