require 'rails_helper'

feature 'User can see questions list', %q{
  In order to get answer for any question
  I'd like to be able to see all questions
} do


  given(:user) {create(:user) }
  let!(:questions) { create_list :question, 3, author: user }

  scenario 'User can see questions list' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end