require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
} do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create :question, author: user }
  given!(:answer) { create :answer, question: question, author: user }

  describe 'Unauthenticated user' do
    scenario 'can not edit question' do
      visit question_path(question)

      expect(page).to_not have_link 'Edit Question'
    end

    scenario '' do
      visit question_path(question)

      expect(page).to_not have_link 'Delete file'
    end
  end

  describe 'Authenticated user', js: true do
    describe 'Author' do
      scenario 'edit his question' do
        sign_in user
        visit question_path(question)
        click_on 'Edit Question'

        fill_in 'Title', with: 'edited question title'
        fill_in 'Question body', with: 'edited question body'
        click_on 'Save'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited question title'
        expect(page).to have_content 'edited question body'
        expect(page).to_not have_selector 'text_field'
      end

      scenario 'edit his question with errors' do
        sign_in user
        visit question_path(question)
        click_on 'Edit Question'

        fill_in 'Title', with: ''
        fill_in 'Question body', with: 'edited question body'
        click_on 'Save'

        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content question.title
        expect(page).to have_selector('input', id: 'question_title')
      end

      describe 'files action' do
        background do
          sign_in user
          visit question_path(question)
          click_on 'Edit Question'
        end

        scenario 'edit question with attached file' do
          within ('.question-block') {
            attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
            click_on 'Save'
          }

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end

        scenario 'edit question: delete an attached file' do
          within ('.question-block') do
            attach_file 'Files', "#{Rails.root}/spec/rails_helper.rb"
            click_on 'Save'
            click_on 'Delete file'
          end

          expect(page).to_not have_link 'rails_helper.rb'
        end

        scenario 'delete file of other user' do
          within ('.question-block') do
            attach_file 'Files', "#{Rails.root}/spec/rails_helper.rb"
            click_on 'Save'
          end

          sign_out #user
          sign_in(user2)

          expect(page).to_not have_link 'Delete file'
        end
      end

    end

    describe 'Not Author' do
      scenario "tries to edit other user's question" do
        sign_in user2
        visit question_path(question)

        expect(page).to_not have_button 'Edit Question'
      end
    end
  end
end
