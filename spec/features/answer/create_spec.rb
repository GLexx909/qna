require 'rails_helper'

feature 'User can create answer', %q{
  In order to send an answer to a community
  As an authenticated user
  I'd like to be able to create the answer
} do

  given(:user) {create(:user) }
  given!(:question) { create :question, author: user }


  describe 'Authenticate user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'create an answer', js: true do
      fill_in 'Body', with: 'text text text'
      click_on 'Post Your Answer'

      within '.answers' do
        expect(page).to have_content 'text text text'
      end
    end

    scenario 'create an answer with error', js: true do
      click_on 'Post Your Answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'create an answer with attached file', js: true do
      fill_in 'Body', with: 'text text text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Post Your Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user tries to create an answer' do
    visit question_path(question)

    fill_in 'Body', with: 'Non auth text'
    click_on 'Post Your Answer'

    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end
end
