require 'rails_helper'

feature 'Author of question can assign a badge', %q{
  In order to reward an user
  Who give the correct answer
  I as an question's author
  I'd like to be able to assign a badge
}do

  given(:user) { create :user}
  given(:question) { create :question, author: user }

  scenario 'User adds link when asks question', js: true do
    sign_in(user)
    visit questions_path
    click_on 'Ask question'

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    click_on 'Assign badge'

    fill_in 'Name', with: 'Test Badge Name'
    fill_in 'Img', with: 'Test Badge Image'

    click_on 'Ask'

    expect(page).to have_content 'Your question successfully created.'
    expect(user.questions.last.badge).to be_a(Badge)
  end
end
