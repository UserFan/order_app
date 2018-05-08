class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

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

  def set_index_render(search, main_collection, new_path )
    render partial: "catalog/catalog_list",
            locals: { q: search,
                      title: t('.caption_title'),
                      caption_button: t('.caption_button'),
                      main_collection: main_collection,
                      new_path: new_path }
  end

  def set_new_edit_render(catalog_name, index_path)
    render partial: 'catalog/catalog_new_edit',
           locals: { title: t('.caption_text'),
           catalog_name: catalog_name,
           index_path: index_path }
  end
  
end
