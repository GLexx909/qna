require 'rails_helper'

feature 'User can sign out', %q{
  I'd like to be able to sign out
} do

  given(:user) { create(:user) }
  background { visit new_user_session_path }

  scenario 'Registered user tries to sign out' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
