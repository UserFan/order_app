class PagesPolicy < Struct.new(:user, :pages)

  def menu_item?(item_name)
    access_type?(item_name, 'menu_show') || user.super_admin?
  end

  def catalog?
    access_type?('catalog', 'menu_show') || user.super_admin?
  end

  def home?
    true
  end

  private

  def access_type?(resource_name, action_name)
    type_access =
      user.template_accesses.where(enum_resources: { resource_name: resource_name },
          enum_actions: { action_name: action_name }).includes(:enum_resource).
            joins(enum_resource: :enum_action).pluck(:enum_type_access_id)

    if type_access.present? && type_access.join.to_i != EnumTypeAccess::NOTALLOWED
      return true
    else
      return false
    end
  end
end
