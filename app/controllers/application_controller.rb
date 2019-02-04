class ApplicationController < ActionController::Base
  include Pundit
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception, prepend: true
  before_action :set_user, :set_translate_default_scope

  rescue_from Pundit::NotAuthorizedError, with: :permission_denied

  protected

  def configure_permitted_parameters
    added_attrs = [:full_name, :mobile, :role_id, :email, :position_id, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  private

  def permission_denied
    flash[:danger] = 'Доступ запрещен. Вы перенаправлены в главную страницу!!!'
    redirect_to root_path
  end

  def default_url_options
    { unit: params[:unit] || 'shop' }
  end

  def set_user
    Current.user = current_user
  end

  def set_translate_default_scope
    @t_base = [:activerecord, :attributes]
  end
end
