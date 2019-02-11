require 'rails_helper'

feature 'User can subscribe to question', %q{
  In order to subscribe to question
  And receive a letter
  I as authenticated user
  I'd like to be able to subscribe
  By click to the bell link
}do
  given(:user) { create :user}
  given(:user_not_author) { create(:user) }
  given(:question) { create :question, author: user }

  scenario 'User can click to bell link to subscribe', js: true do
    sign_in(user_not_author)
    visit question_path(question)

    find('.subscribe a').click

    expect(page).to have_css('.subscribe  a  i.orange600')
    expect(user_not_author.subscriptions.last).to be_a(Subscription)
    expect(user_not_author.subscriptions.count).to eq(1)
    expect(user_not_author.subscriptions.last.question).to eq(question)
  end

  scenario 'User can click to bell link to unsubscribe', js: true do
    sign_in(user)
    visit question_path(question)

    expect(user.subscriptions.count).to eq(1)

    find('.subscribe a').click

    expect(page).to_not have_css('.subscribe  a  i.orange600')
    expect(user_not_author.subscriptions.count).to eq(0)
  end
end
