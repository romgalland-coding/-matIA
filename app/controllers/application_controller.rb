class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  allow_browser versions: :modern


  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:user_name, devices: []])
    devise_parameter_sanitizer.permit(:account_update, keys: [:user_name])
  end
end
