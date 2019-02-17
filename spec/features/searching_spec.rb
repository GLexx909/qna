require 'rails_helper'

# Тест условный.

feature 'Search' do
  given!(:user){ create(:user) }
  given!(:question){ create(:question, author: user) }

  before do
    index
    visit root_path
  end

  scenario 'in all context' do
    within('.search-block') do
      select 'Global_Search', from: 'category'
      fill_in 'search', with: 'Test title'
      click_on 'Find it'
    end

    expect(page).to have_link('to Question')
  end
end
