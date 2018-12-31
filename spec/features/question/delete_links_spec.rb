require 'rails_helper'

feature 'User can delete links from question', %q{
  In order to correct info from my question
  As an question's author
  I'd like to be able to delete links
}do
  given(:user) { create :user }
  given(:user1) { create :user }
  given!(:question) { create :question, author: user }
  given!(:link) { create :link, linkable: question }

  scenario 'Author delete the link', js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'Delete link'

    expect(page).to_not have_link 'MyLink'
    expect(page).to_not have_button 'Delete link'
  end

  scenario 'Not author try to delete the link', js: true do
    sign_in(user1)
    visit question_path(question)

    expect(page).to_not have_button 'Delete link'
  end
end
