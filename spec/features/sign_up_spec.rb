require 'rails_helper'

feature 'User can sign up', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign up
} do

  scenario 'Registered user tries to sign up' do
    visit new_user_registration_path
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'

    find_button('Sign up').click
    expect(page).to have_content 'A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.'
  end

  scenario 'Registered user tries to sign up with confirmation' do
    visit new_user_registration_path

    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'

    find_button('Sign up').click
    expect(page).to have_content 'A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.'

    open_email('user@test.com')
    current_email.click_link 'Confirm my account'

    expect(page).to have_content 'Your email address has been successfully confirmed.'
  end
end
