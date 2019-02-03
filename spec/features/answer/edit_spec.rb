require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create :question, author: user }
  given!(:answer) { create :answer, question: question, author: user }

  describe "Unauthenticated user" do
    scenario 'can not edit answer' do
      visit question_path(question)

      expect(page).to_not have_link 'Edit'
    end

    scenario 'can not delete file' do
      visit question_path(question)

      expect(page).to_not have_link 'Delete file'
    end
  end

  describe 'Authenticated user' do
    scenario 'edit his answer', js: true do
      sign_in user
      visit question_path(question)
      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    describe 'files action' do
      scenario 'edit answer with attached file', js: true do
        sign_in user
        visit question_path(question)
        click_on 'Edit'

        within ('.answers') do
          attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'
        end

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end

      scenario 'edit answer: delete an attached file', js: true do
        sign_in user
        visit question_path(question)
        click_on 'Edit'

        within ('.answers') do
          attach_file 'Files', "#{Rails.root}/spec/rails_helper.rb"
          click_on 'Save'
          click_on 'Delete file'
        end

        expect(page).to_not have_link 'rails_helper.rb'
      end

      scenario 'delete file of other user', js: true do
        sign_in user
        visit question_path(question)
        click_on 'Edit'

        within ('.answers') do
          attach_file 'Files', "#{Rails.root}/spec/rails_helper.rb"
          click_on 'Save'
        end

        sign_out #User
        sign_in(user2)

        expect(page).to_not have_link 'Delete file'
      end
    end

    scenario 'edit his answer with errors', js: true do
      sign_in user
      visit question_path(question)
      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: ''
        click_on 'Save'

        expect(page).to have_content "Body can't be blank"
        expect(page).to have_content answer.body
        expect(page).to have_selector 'textarea'
      end
    end

    scenario 'edit answer: add link', js: true do
      sign_in user
      visit question_path(question)

      within ('.card') do
        click_on 'Edit'
        click_on 'Add link'

        fill_in 'Link name', with: 'MyLink'
        fill_in 'Url', with: 'http://example.com'

        click_on 'Save'
      end

      expect(page).to have_link 'MyLink', href: 'http://example.com'
    end

    scenario "tries to edit other user's answer" do
      sign_in user2
      visit question_path(question)

      within ('.card') do
        expect(page).to_not have_button 'Edit'
      end
    end
  end
end
