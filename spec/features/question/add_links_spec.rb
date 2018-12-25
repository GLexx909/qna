require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
}do
  given(:user) { create :user}
  given(:gist_url) { 'https://gist.github.com/GLexx909/c42ece3b09b5672cdcfd9c7280dfcb7a' }

  scenario 'User adds link when asks question' do
    sign_in(user)
    visit questions_path
    click_on 'Ask question'

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
  end
end
