class PreregistrationsController < ApplicationController

  def show
  end

  def create
    email = params[:email]
    if email_check.match(email)
      cookies[:pre_email] = email
      password = Devise.friendly_token[0, 20]
      User.create!(email: email, password: password, password_confirmation: password)
    else
      flash.now[:alert] = 'Email is not valid'
      render :show
    end
  end

  private

  def email_check
    (/.+@.+\..+/i)
  end
end
