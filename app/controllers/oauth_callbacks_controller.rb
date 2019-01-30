class OauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    if email_cookie_persisted?(request.env['omniauth.auth'])
      redirect_to preregistrations_show_path, alert: %q{
        Facebook не предоставил Email.
        Пожалуйста, зарегистрируйте и подтвердите ваш Email.
        После подтверждения Email вы сможете авторизоваться через Facebook.
      }
      return
    end

    @user = User.find_for_oauth(request.env['omniauth.auth'], cookies[:pre_email])

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  private

  def email_cookie_persisted?(auth)
    auth['info']['email'].blank? && !user_signed_in? && !cookies[:pre_email]
  end
end
