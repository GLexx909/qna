class OauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    do_action(__method__.to_s)
  end

  def github
    do_action(__method__.to_s)
  end

  private

  def do_action(provider_name)
    if email_not_persisted?(request.env['omniauth.auth'])
      redirect_to new_preregistration_path, alert: %Q{
        #{provider_name} не предоставил Email.
        Пожалуйста, зарегистрируйте и подтвердите ваш Email.
        После подтверждения Email вы сможете авторизоваться через #{provider_name}.
      }
      return
    end

    @user = User.find_for_oauth(request.env['omniauth.auth'], session[:pre_email])

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider_name) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def email_not_persisted?(auth)
    auth['info']['email'].blank? && !user_signed_in? && !session[:pre_email]
  end
end
