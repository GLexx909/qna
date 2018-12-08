require 'rails_helper'

feature "User can see a question with it's answers", %q{
  In order to see answers for a question
  From community
  I'd like to be able to see current question page
} do


  given(:user) {create(:user) }
  let!(:question) { create :question, author: user }
  let!(:answers) { create_list :answer, 3, author: user, question: question }

  scenario 'User can see questions list' do
    visit questions_path
    click_on 'Answers'

    answers.each do |answers|
      expect(page).to have_content answers.body
    end
  end
end