require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
}do
  given(:user) { create :user}
  given(:url) { 'https://github.com' }

  scenario 'User adds link when asks question', js: true do
    sign_in(user)
    visit questions_path
    click_on 'Ask question'

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    click_on 'Add link'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: url

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: url
  end
end
