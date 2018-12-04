require 'rails_helper'

feature 'User can sign up', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign up
} do

  given(:user) { create(:user) }
  background { visit new_user_registration_path }

  scenario 'Registered user tries to sign up' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    # click_on 'Sign up'
    find_button('Sign up').click
    save_and_open_page #Здесь не проходит т.к. "Email has already been take". Не могу понять.
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end
end