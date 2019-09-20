class PagesPolicy < Struct.new(:user, :pages)

  def menu_item?(item_name)
    access_type?(item_name, 'show') || user.super_admin?
  end

  def catalog?
    access_type?('catalog', 'show') || user.super_admin?
  end

  def home?
    true
  end

  private

  def access_type?(tabl_name, action_name)
    type_access =
      user.template_roles.where("resource_names.table_name = ? AND action_apps.action_app_name = ?",
        tabl_name, action_name).joins(action_name: [:action_app, :resource_name]).pluck(:type_access)
    if type_access.present?
      if (type_access.join == 'allowed_all') ||
         (type_access.join == 'allowed_current')
         return true
      else
        return false
      end
    else
      return false
    end
  end
end
