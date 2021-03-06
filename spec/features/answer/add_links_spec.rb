require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
}do
  given(:user) { create :user}
  given!(:question) { create :question, author: user}
  given(:link_url) { 'https://example.com' }

  scenario 'User adds link when give an answer', js: true do
    sign_in(user)
    visit question_path(question)

    within('.answer-new-form') do
      fill_in 'Body', with: 'text text text'

      click_on 'Add link'

      fill_in 'Link name', with: 'MyLink'
      fill_in 'Url', with: link_url

      click_on 'Post Your Answer'
    end

    expect(page).to have_link 'MyLink', href: link_url
  end

end
