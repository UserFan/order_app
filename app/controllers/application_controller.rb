class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :permission_denied

  protected

  def configure_permitted_parameters
    added_attrs = [:full_name, :mobile, :email, :position, :role, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  private

  def permission_denied
    flash[:danger] = 'Доступ запрещен. Вы перенаправлены в главную страницу!!!'
    redirect_to root_path
  end

end
