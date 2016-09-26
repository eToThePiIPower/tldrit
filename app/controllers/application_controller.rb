class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def configure_permitted_parameters
    social_params = [:facebook, :twitter, :google_plus]
    user_params = [:username, :homepage]
    devise_parameter_sanitizer.permit(:sign_up, keys: social_params + user_params)
    devise_parameter_sanitizer.permit(:account_update, keys: social_params + user_params)
  end
end
