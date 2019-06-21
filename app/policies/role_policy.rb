class RolePolicy < ApplicationPolicy

  def permitted_attributes
    [:name] if user.super_admin? || (access_type?('edit') || access_type?('new'))
  end
end
