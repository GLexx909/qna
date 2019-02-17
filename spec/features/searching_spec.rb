require 'rails_helper'
require 'support/sphinx'
# Тест условный.

feature 'Search' do
  given!(:user){ create(:user) }
  given!(:question){ create(:question, author: user) }

  scenario 'in all context', js: true do
    ThinkingSphinx::Test.run do
      index
      visit root_path
      within('.search-block') do
        select 'Global_Search', from: 'category'
        fill_in 'search', with: 'Test title'
        click_on 'Find it'
      end

      expect(page).to have_link('to Question')
    end
  end
end
