class ApplicationController < ActionController::Base

  check_authorization unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|

    respond_to do |format|
      format.html { redirect_to root_path, alert: exception.message }
      format.js { render json: exception.message, status: :forbidden }
      format.json { render json: exception.message, status: :forbidden }
    end
  end
end
